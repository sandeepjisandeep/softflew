//
//  StringExtension.swift
//  SoftFlewDemo
//
//  Created by Sandeep Srivastava on 28/01/23.
//  Copyright © 2023 Sandeep. All rights reserved.
//

import Foundation
extension String {
    
    func localizableString(loc:String) -> String{
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName:nil,bundle:bundle!,value: "", comment: "")
        
        
        
    }
    
    
    
}
