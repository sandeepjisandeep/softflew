//
//  userTableViewDataSource.swift
//  SoftFlewDemo
//
//  Created by Sandeep Srivastava on 26/01/23.
//  Copyright © 2023 Sandeep. All rights reserved.
//

import Foundation
import UIKit

class userTableViewDataSource<CELL : UITableViewCell,T> : NSObject, UITableViewDataSource {

    private var cellIdentifier : String!
    private var items : [T]!
    var configureCell : (userTableViewCell, T, Int) -> () = {_,_,_ in }
    var page = 1
    
    init(cellIdentifier : String, items : [T], configureCell : @escaping (userTableViewCell, T, Int) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items =  items
        self.configureCell = configureCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! userTableViewCell
        
        let item = self.items[indexPath.row]
        self.configureCell(cell, item,indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    

}


