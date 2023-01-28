//
//  File.swift
//  SoftFlewDemo
//
//  Created by Sandeep Srivastava on 26/01/23.
//  Copyright © 2023 Sandeep. All rights reserved.
//

import Foundation


// MARK: - UserData
struct UserData: Decodable {
    let id:Int?
    let nodeId, name, fullName: String
    let owner:ownerData?
    var isFav:Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case nodeId = "node_id"
        case name = "name"
        case fullName = "full_name"
        case owner
    }
    
    
}
struct ownerData: Decodable {
    let id:Int?
    let nodeId, photoUrl: String
     

    enum CodingKeys: String, CodingKey {
        
        case id
        case nodeId = "node_id"
        case photoUrl = "avatar_url"
       
       
    }
    
    
}
