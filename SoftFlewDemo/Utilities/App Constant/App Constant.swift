//
//  App Constant.swift
//  SoftFlewDemo
//
//  Created by Sandeep Srivastava on 26/01/23.
//  Copyright © 2023 Sandeep. All rights reserved.
//

import Foundation
let userdefault = UserDefaults.standard
var isAPIAtLastItem = false
let apiUrl = "https://api.github.com/users/JakeWharton/repos?page={page_no}&per_page=15"
enum UserDefaultKeys:String{
    
  case isdefaultLanguageON = "is_default_language_on"
    
    
    
}
