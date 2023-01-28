//
//  ApiServices.swift
//  SoftFlewDemo
//
//  Created by Sandeep Srivastava on 26/01/23.
//  Copyright © 2023 Sandeep. All rights reserved.
//

import Foundation

class APIService :  NSObject {
    
    
    
    func apiToGetEmployeeData(_ page:Int  ,completion : @escaping ([UserData]) -> ()){
        let apiString = apiUrl.replacingOccurrences(of: "{page_no}", with: "\(page)", options: .literal, range: nil)
        print(apiString)
        let sourcesURL = URL(string:apiString)!
        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
            if let data = data {
                
                let jsonDecoder = JSONDecoder()
                
                let empData = try! jsonDecoder.decode([UserData].self, from: data)
                    completion(empData)
            }
        }.resume()
    }
}
