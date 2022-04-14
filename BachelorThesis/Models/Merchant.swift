//  Created by Filip Kjamilov on 27.2.22.

import RealmSwift
import Foundation
import AVFoundation
import UIKit
import CoreLocation

public enum CodeType: String, PersistableEnum {
    
    case unknown
    case CICode128BarcodeGenerator
    case CIQRCodeGenerator
    
}

class MerchantDto: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var downloadedImage: Data?
    @Persisted var image: String = ""
    @Persisted var locations: List<LocationsDto>
    @Persisted var scannedCode: String?
    @Persisted var typeOfCode: CodeType? = .unknown
    @Persisted var distance: CLLocationDistance = .greatestFiniteMagnitude
    
    public func getName() -> String {
        return name
    }
    
    // TODO: FKJ - Pass array of locations directly, avoid casting them here.
    convenience init(name: String, image: String, locations: [String: [String: Any]]?) {
        self.init()
        self.name = name
        self.image = image
        if locations != nil {
            locations?.forEach { location in
                let latitude = location.value["latitude"] as? Double ?? 0.00
                let longitude = location.value["longitude"] as? Double ?? 0.00
                self.locations.append(LocationsDto(longitude: longitude, latitude: latitude))
            }
        }
    }
}

class LocationsDto: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var longitude: Double = 0.0
    @Persisted var latitude: Double = 0.0
    
    @Persisted(originProperty: "locations") var assignee: LinkingObjects<MerchantDto>
    
    convenience init(longitude: Double, latitude: Double) {
        self.init()
        self.longitude = longitude
        self.latitude = latitude
    }
}
