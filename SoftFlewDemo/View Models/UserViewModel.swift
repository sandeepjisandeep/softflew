//
//  UserViewModel.swift
//  SoftFlewDemo
//
//  Created by Sandeep Srivastava on 26/01/23.
//  Copyright © 2023 Sandeep. All rights reserved.
//

import Foundation

class UserViewModel : NSObject {
    
    private var apiService : APIService!
    private(set) var empData :[UserData]! {
        didSet {
            self.bindEmployeeViewModelToController()
        }
    }
    
    var bindEmployeeViewModelToController : (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiService =  APIService()
        callFuncToGetEmpData()
    }
    
    func callFuncToGetEmpData(_ page:Int=1) {
        self.apiService.apiToGetEmployeeData(page) { (empData) in
            self.empData = empData
        }
    }
    func updateEmpValue(_ userData:UserData,_ index:Int){
        self.empData[index] = userData
        
    }
    
    func setUserValues(userDataArr:[UserData]){
        self.empData = userDataArr
    }
    
    func apiCallForPagination(page:Int){
        self.apiService.apiToGetEmployeeData(page) { (empData) in
            if page == 1 {
                self.empData = empData
            }else{
                if empData.count < 1{
                    isAPIAtLastItem = true
                }
                    self.empData.append(contentsOf: empData)
            }
        }
    }
    
    
}
