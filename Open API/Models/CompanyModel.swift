//
//  CompanyModel.swift
//  Open API
//
//  Created by Ruslan Yelguldinov on 11.08.2024.
//

import UIKit
import SwiftyJSON

struct CompanyModel {
    var name: String = "No data"
    var city: String = "No data"
    var street: String = "No data"
    var typeOfActivity: String = "No data"
//    var photoURL: String = "No data"
    
    init() {
    
    }
    
    init(json: JSON) {
        
        if let temp = json["name"].string {
            self.name = temp
        }
        if let temp = json["addresses"]["business"]["city"].string {
            self.city = temp
        }
        if let temp = json["addresses"]["business"]["street1"].string {
            self.street = temp
        }
        if let temp = json["sicDescription"].string {
            self.typeOfActivity = temp
        }
//        if let temp = json["photoURL"].string {
//            self.photoURL = temp
//        }
        
    }
    
}
//if let temp = json["id"].int {
//    self.id = temp
//}
