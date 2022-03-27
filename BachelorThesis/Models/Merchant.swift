//  Created by Filip Kjamilov on 27.2.22.

import RealmSwift
import Foundation
import AVFoundation
import UIKit

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
    
    public func getName() -> String {
        return name
    }
    
    // TODO: FKJ - Locations are hard coded?
    convenience init(name: String, image: String, locations: [String: Any]?) {
        self.init()
        self.name = name
        self.image = image
        if locations != nil {
            locations?.forEach { location in
                self.locations.append(LocationsDto(logitude: 22.2, latitude: 22.2))
            }
        }
    }
    
    // TODO: FKJ - Remove unnecessary inits.
    convenience init(name: String, image: String, locations: [String: Any]?, downloadedImage: Data?) {
        self.init()
        self.name = name
        self.image = image
        self.downloadedImage = downloadedImage
        if locations != nil {
            locations?.forEach { location in
                self.locations.append(LocationsDto(logitude: 22.2, latitude: 22.2))
            }
        }
    }
    
    convenience init(name: String, image: String, locations: [String: Any]?, scannedCode: String?, typeOfCode: CodeType?, downloadedImage: Data?) {
        self.init()
        self.name = name
        self.image = image
        self.downloadedImage = downloadedImage
        if locations != nil {
            locations?.forEach { location in
                self.locations.append(LocationsDto(logitude: 22.2, latitude: 22.2))
            }
        }
        self.scannedCode = scannedCode
        self.typeOfCode = typeOfCode
    }
    
    convenience init(name: String, image: String, locations: [String: Any]?, scannedCode: String?, typeOfCode: CodeType?) {
        self.init()
        self.name = name
        self.image = image
        if locations != nil {
            locations?.forEach { location in
                self.locations.append(LocationsDto(logitude: 22.2, latitude: 22.2))
            }
        }
        self.scannedCode = scannedCode
        self.typeOfCode = typeOfCode
    }
}

class LocationsDto: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var longitude: Double = 0.0
    @Persisted var latitude: Double = 0.0
    
    @Persisted(originProperty: "locations") var assignee: LinkingObjects<MerchantDto>
    
    convenience init(logitude: Double, latitude: Double) {
        self.init()
        self.longitude = longitude
        self.latitude = latitude
    }
}
