//  Created by Filip Kjamilov on 28.2.22.

import Foundation
import RealmSwift
import UIKit
import CoreLocation
import FirebaseStorage

class RealmManager: ObservableObject {
    
    @Published var merchants: [MerchantDto] = []
    
    static let shared = RealmManager()
    var localRealm = try! Realm()
    
    private let storage = Storage.storage().reference()
    
    private init() {
        getMerchants()
    }
    
    public func addMerhant(name: String,
                           image: String,
                           locations: List<LocationsDto>,
                           scannedCode: String,
                           typeOfCode: CodeType) {

        storage.child("MKD/Tinex.png").downloadURL(completion: { url, error in
            guard let url = url, error == nil else { return }
            guard let imageURL = URL(string: url.absoluteString) else { return }
            print("Continues")
            
            
            
            URLSession.shared.dataTask(with: imageURL, completionHandler: { data, _, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    let merchant = MerchantDto(value: ["name": name,
                                                       "downloadedImage": data,
                                                       "image": image,
                                                       "locations": locations,
                                                       "scannedCode": scannedCode,
                                                       "typeOfCode": typeOfCode])
                    
                    do {
                        try self.localRealm.write {
                            self.localRealm.add(merchant)
                        }
                    } catch {
                        print("Error adding merchant: \(error)")
                    }
                    self.getMerchants()
                }
                
            }).resume()
        })
        
        
        
    }
    
    func getMerchants() {
        let allMerchants = localRealm.objects(MerchantDto.self)
        merchants = []
        allMerchants.filter({ !$0.isInvalidated }).forEach { merchant in
            merchants.append(merchant)
        }
    }
    
    func deleteMerchant(id: ObjectId) {
        do {
            let merchantToRemove = localRealm.objects(MerchantDto.self).filter(NSPredicate(format: "id == %@", id))
            guard !merchantToRemove.isEmpty else { return }
            
            try localRealm.write {
                localRealm.delete(merchantToRemove)
                getMerchants()
            }
            
        } catch {
            print("Error deleting merchant!")
        }
    }
    
    public func sortCards(with location: CLLocation) {
        do {
            
            try localRealm.write {
                
                self.merchants.forEach { merchant in
                    merchant.distance = .greatestFiniteMagnitude
                    merchant.locations.forEach { merchantLocation in
                        let distance = location
                            .distance(from: CLLocation(latitude: merchantLocation.latitude,
                                                       longitude: merchantLocation.longitude))
                        
                        if merchant.distance > distance { merchant.distance = distance }
                    }
                }
                
                self.merchants.sort { $0.distance < $1.distance }
            }
            
        } catch {
            // TODO: FKJ - Error handling
            print("Error: \(error)")
        }
        
    }
    
}
