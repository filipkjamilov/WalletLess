//  Created by Filip Kjamilov on 28.2.22.

import Foundation
import RealmSwift
import UIKit
import CoreLocation

class RealmManager: ObservableObject {
    
    @Published var merchants: [MerchantDto] = []
    
    static let shared = RealmManager()
    
    var localRealm = try! Realm()
    
    private init() {
        //        openRealm()
        getMerchants()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
            localRealm = try Realm()
        } catch {
            print("Error opening Realm: \(error)")
        }
    }
    
    func addMerhant(name: String, image: String, locations: List<LocationsDto>, scannedCode: String, typeOfCode: CodeType) {
        do {
            try localRealm.write {
                let imageURL = URL(string: image)!
                let downloadedImage = try Data(contentsOf: imageURL)
                let merchant = MerchantDto(value: ["name": name,
                                                   "downloadedImage": downloadedImage,
                                                   "image": image,
                                                   "locations": locations,
                                                   "scannedCode": scannedCode,
                                                   "typeOfCode": typeOfCode])
                localRealm.add(merchant)
                getMerchants()
                print("New merchant added")
            }
        } catch {
            print("Error adding merchant: \(error)")
        }
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
                print(self.merchants.first?.name ?? "")
            }
            
        } catch {
            // TODO: FKJ - Error handling
            print("Error: \(error)")
        }
        
    }
    
}
