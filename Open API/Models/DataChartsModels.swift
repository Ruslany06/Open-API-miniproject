//
//  DataChartsModels.swift
//  Open API
//
//  Created by Ruslan Yelguldinov on 13.08.2024.
//

import UIKit
import SwiftyJSON

struct NetIncomeLoss {
    var title: String = ""
    var description: String = ""
    var entityName: String = ""
    var listYear: [Int] = []
    var listValue: [Int] = []
    var yearlyValues: [Int: Double] = [:]
    
    init() {}
    
    init(json: JSON) {
        
        if let temp = json["label"].string {
            self.title = temp
        }
        if let temp = json["description"].string {
            self.description = temp
        }
        if let temp = json["entityName"].string {
            self.entityName = "Total profit of " + temp
        }
//        // Fetching data from "USD" array, which is value in the "units" key. In the "USD" array "fy" and "val" keys included.
//        if let unitsArray = json["units"]["USD"].array {
//            
//            for unit in unitsArray {
//                if let year = unit["fy"].int {
//                    listYear.append(year)
//                }
//                if let value = unit["val"].int {
//                    listValue.append(value)
//                }
//            }
//        }
        
        if let unitsArray = json["units"]["USD"].array {
            for unit in unitsArray {
                if let year = unit["fy"].int, let value = unit["val"].double {
                    // Суммируем значения для одного года
                    yearlyValues[year, default: 0] += value
                }
            }
        }
        
    }
}

struct GrossProfit {
    var title: String = ""
    var description: String = ""
    var listYear: [Int] = []
    var listValue: [Int] = []
    var yearlyValues: [Int: Double] = [:]
    
    init() {}
    
    init(json: JSON) {
        
        if let temp = json["label"].string {
            self.title = temp
        }
        if let temp = json["description"].string {
            self.description = temp
        }
        
        if let unitsArray = json["units"]["USD"].array {
            for unit in unitsArray {
                if let year = unit["fy"].int, let value = unit["val"].double {
                    // Суммируем значения для одного года
                    yearlyValues[year, default: 0] += value
                }
            }
        }
            
    }
}

struct OperatingIncomeLoss {
    var title: String = ""
    var description: String = ""
    var listYear: [Int] = []
    var listValue: [Int] = []
    var yearlyValues: [Int: Double] = [:]
    
    init() {}
    
    init(json: JSON) {
        
        if let temp = json["label"].string {
            self.title = temp
        }
        if let temp = json["description"].string {
            self.description = temp
        }
        
        if let unitsArray = json["units"]["USD"].array {
            for unit in unitsArray {
                if let year = unit["fy"].int, let value = unit["val"].double {
                    // Суммируем значения для одного года
                    yearlyValues[year, default: 0] += value
                }
            }
        }
        
    }
}

