//
//  ObjectExtension.swift
//  SoftFlewDemo
//
//  Created by Sandeep Srivastava on 27/01/23.
//  Copyright © 2023 Sandeep. All rights reserved.
//

import Foundation
import CoreData
extension NSManagedObject {
    func toDict() -> [String:Any] {
        let keys = Array(entity.attributesByName.keys)
        return dictionaryWithValues(forKeys:keys)
    }
}
