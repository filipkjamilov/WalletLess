//
//  RealmManager.swift
//  BachelorThesis
//
//  Created by Filip Kjamilov on 28.2.22.
//

import Foundation
import RealmSwift
import UIKit

class RealmManager: ObservableObject {
    private(set) var localRealm: Realm?
    @Published private(set) var merchants: [MerchantDto] = []
    @Published private(set) var merchantsFireStore: [MerchantsFireStore] = []
    
    init() {
        openRealm()
        getMerchants()
        getMerchantsFireStore()
    }
    
    func openRealm() {
        do {
            
//            let config = Realm.Configuration(schemaVersion: 1)
//
//            Realm.Configuration.defaultConfiguration = config
//
            localRealm = try Realm()
            
        } catch {
            print("Error opening Realm: \(error)")
        }
    }
    
    func addMerhant(name: String, image: String, locations: List<LocationsDto>, scannedCode: String, typeOfCode: CodeType) {
        if let localRealm = localRealm {
            do {
                
                let imageURL = URL(string: image)!
                let downloadedImage = try Data(contentsOf: imageURL)
                
                try localRealm.write {
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
    }
    
    func addMerhantFireStore(name: String, image: String, locations: [String: Any]?) {
        if let localRealm = localRealm {
            do {
                
                let imageURL = URL(string: image)!
                let downloadedImage = try Data(contentsOf: imageURL)
                
                try localRealm.write {
                    let merchant = MerchantsFireStore(value: ["name": name,
                                                              "image": downloadedImage,
                                                              "locations": locations])
                    localRealm.add(merchant)
                    getMerchantsFireStore()
                    print("New merchant firestore added")
                }
            } catch {
                print("Error adding merchant: \(error)")
            }
        }
    }
    
    func getMerchants() {
        if let localRealm = localRealm {
            let allMerchants = localRealm.objects(MerchantDto.self)
            merchants = []
            allMerchants.forEach { merchant in
                merchants.append(merchant)
            }
            
        }
    }
    
    func getMerchantsFireStore() {
        if let localRealm = localRealm {
            let allMerchants = localRealm.objects(MerchantsFireStore.self)
            merchantsFireStore = []
            allMerchants.forEach { merchant in
                merchantsFireStore.append(merchant)
            }
            
        }
    }
    
    func deleteMerchant(id: ObjectId) {
        if let localRealm = localRealm {
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
    }
    
}
