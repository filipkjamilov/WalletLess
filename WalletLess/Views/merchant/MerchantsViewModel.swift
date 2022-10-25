//  Created by Filip Kjamilov on 21.10.22.

import Foundation
import FirebaseStorage
import FirebaseDatabase
import CodeScanner
import MessageUI

public final class MerchantsViewModel: ObservableObject {
    
    @Published var merchants = [MerchantDto]()
    let databaseName: String = "Development"
    
    @Published public var isPresentingScanner = false
    @Published public var isPresentingMailView = false
    @Published public var alertForMail = false
    @Published public var isTorchOn = false
    
    private let storage = Storage.storage().reference()
    private var realmManager = RealmManager.shared
    
    func fetchDataIfNeeded() {
        let database = Database.database().reference().child(databaseName)
        
        database.observe(.value) { snapshot in
            
            guard let dict = snapshot.value as? [String:Any] else { return }
            
            dict.forEach { card in
                let card = card.value as? [String: Any]
                
                let name = card?["cardName"] as? String ?? ""
                let locations = card?["locations"] as? [String: [String: Any]]
                
                self.storage.child("MKD/\(name).png").downloadURL(completion: { url, error in
                    guard let url = url, error == nil else { return }
                    guard let imageURL = URL(string: url.absoluteString) else { return }
                    
                    URLSession.shared.dataTask(with: imageURL, completionHandler: { data, _, error in
                        guard let data = data, error == nil else { return }
                        
                        DispatchQueue.main.async {
                            self.merchants.append(MerchantDto(name: name, downloadedImage: data, locations: locations))
                        }
                        
                    }).resume()
                })
            }
        }
    }
        
    func mapScannedCode(with result: (ScanResult), merchant: MerchantDto) {
        switch result.type {
        case .code128:
            realmManager.addMerhant(name: merchant.name,
                                    image: merchant.image,
                                    locations: merchant.locations,
                                    scannedCode: result.string,
                                    typeOfCode: .CICode128BarcodeGenerator)
        case .qr:
            realmManager.addMerhant(name: merchant.name,
                                    image: merchant.image,
                                    locations: merchant.locations,
                                    scannedCode: result.string,
                                    typeOfCode: .CIQRCodeGenerator)
        default:
            realmManager.addMerhant(name: merchant.name,
                                    image: merchant.image,
                                    locations: merchant.locations,
                                    scannedCode: result.string,
                                    typeOfCode: .CICode128BarcodeGenerator)
        }
    }
    
    func presentMailSheet() {
        if MFMailComposeViewController.canSendMail() {
            // Send inApp email.
            isPresentingMailView.toggle()
        } else {
            // Show alert - MailProviderMissing!
            alertForMail.toggle()
        }
    }
}
