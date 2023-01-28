//
//  favouriteListViewController.swift
//  SoftFlewDemo
//
//  Created by Sandeep Srivastava on 27/01/23.
//  Copyright © 2023 Sandeep. All rights reserved.
//

import UIKit
import CoreData

class favouriteListViewController: UIViewController {
    
    var context:NSManagedObjectContext!
    @IBOutlet weak var tableView: UITableView!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    private var employeeViewModel : UserViewModel!
    private var dataSource : userTableViewDataSource<userTableViewCell,UserData>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userdefault.bool(forKey: UserDefaultKeys.isdefaultLanguageON.rawValue){
            self.title = "UserDetailsKey".localizableString(loc: "en")
            navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "CancelKeys".localizableString(loc: "en"), style: .plain, target: self, action: #selector(cancelBtn))
        }else{
            self.title = "UserDetailsKey".localizableString(loc: "ar")
            navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "CancelKeys".localizableString(loc: "ar"), style: .plain, target: self, action: #selector(cancelBtn))
        }
        tableView.register(UINib(nibName: "userTableViewCell", bundle: nil), forCellReuseIdentifier: "userTableViewCell")
        callToViewModelForUIUpdate()
        fetchData()
        
    }
    
    func callToViewModelForUIUpdate(){
        
        self.employeeViewModel =  UserViewModel()
//        self.employeeViewModel.bindEmployeeViewModelToController = {
//            self.updateDataSource()
//        }
    }
    
    @objc func cancelBtn(){
        self.navigationController?.popViewController(animated:true)
    }
    //MARK:- FETCH DATA FROM THE CORE DATA
    func fetchData()
    {
        print("Fetching Data..")
        var arr = [UserData]()
        context = appdelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let dict = data.toDict()
                let owner = ownerData.init(id: nil, nodeId: "", photoUrl: dict["photoURL"] as? String ?? "")
                let user = UserData.init(id: Int(dict["id"] as? Int16 ?? 0), nodeId: dict["node_id"] as? String ?? "", name: dict["name"] as? String ?? "", fullName: dict["name"] as? String ?? "", owner: owner,isFav:true)
                arr.append(user)
                print(user)
            }
            self.employeeViewModel.setUserValues(userDataArr: arr)
            self.updateDataSource()
            self.tableView.reloadData()
        } catch {
            print("Fetching data Failed")
        }
    }
    func updateDataSource(){
        
        self.dataSource = userTableViewDataSource(cellIdentifier: "userTableViewCell", items: self.employeeViewModel.empData, configureCell: { (cell, evm, row) in
            cell.lbluserId.text = "Node Id: " + (evm.nodeId.description )
            cell.lbluserName.text = evm.fullName
            if let imgURL = evm.owner?.photoUrl{
                cell.userImg.imageFromServerURL(imgURL, placeHolder: nil)
            }
            cell.favouriteBtn.tag = row
            if evm.isFav{
                cell.favouriteBtn.setImage(UIImage(named:"favourite"), for:.normal)
            }else{
                cell.favouriteBtn.setImage(UIImage(named:"unfavourite"), for:.normal)
            }
            cell.favouriteBtn.addTarget(self, action: #selector(self.favUnfavData), for: .touchUpInside)
        })
        
        DispatchQueue.main.async {
            self.tableView.dataSource = self.dataSource
            self.tableView.reloadData()
        }
    }
    
    @objc func favUnfavData(_ sender:UIButton){
        let userData = self.employeeViewModel.empData[sender.tag]
            guard let id = userData.id else { return }
            deleteData(id:Int16(truncatingIfNeeded:id))
    }
    
    //MARK:- DELETE FROM THE CORE DATA
    func deleteData(id:Int16){
        context = appdelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        deleteFetch.predicate = NSPredicate.init(format: "id==\(id)")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
            fetchData()
        } catch {
            print ("There was an error")
        }
        
    }
    
}
