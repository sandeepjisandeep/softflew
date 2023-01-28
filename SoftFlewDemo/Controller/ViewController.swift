//
//  ViewController.swift
//  SoftFlewDemo
//
//  Created by Sandeep Srivastava on 26/01/23.
//

import UIKit
import CoreData
class ViewController: UIViewController, UITableViewDelegate {
    
    var context:NSManagedObjectContext!
    @IBOutlet weak var animationLoaderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var page = 1
    private var employeeViewModel : UserViewModel!
    private var dataSource : userTableViewDataSource<userTableViewCell,UserData>!
    private var localData = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
       

        tableView.register(UINib(nibName: "userTableViewCell", bundle: nil), forCellReuseIdentifier: "userTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userdefault.bool(forKey: UserDefaultKeys.isdefaultLanguageON.rawValue){
            self.title = "UserDetailsKey".localizableString(loc: "en")
            let favLsit = UIBarButtonItem(title: "ShowFavouriteKey".localizableString(loc: "en"), style: .plain, target: self, action: #selector(favouriteList))
            navigationItem.rightBarButtonItems = [favLsit]
            let Settings = UIBarButtonItem(title: "AppSettingsKey".localizableString(loc: "en"), style: .plain, target: self, action: #selector(goTosettings))
            navigationItem.leftBarButtonItems = [Settings]
        }else{
            self.title = "UserDetailsKey".localizableString(loc: "ar")
            let favLsit = UIBarButtonItem(title: "ShowFavouriteKey".localizableString(loc: "ar"), style: .plain, target: self, action: #selector(favouriteList))
            navigationItem.rightBarButtonItems = [favLsit]
            let Settings = UIBarButtonItem(title: "AppSettingsKey".localizableString(loc: "ar"), style: .plain, target: self, action: #selector(goTosettings))
            navigationItem.leftBarButtonItems = [Settings]
        }
        fetchData()
        callToViewModelForUIUpdate()
    }
    
    @objc func favouriteList(){
      let storyboard = UIStoryboard(name:"Main", bundle:nil)
        let goTofavouriteView = storyboard.instantiateViewController(withIdentifier:"favouriteListViewController") as! favouriteListViewController
        
        self.navigationController?.pushViewController(goTofavouriteView, animated:false)
        
    }
    
    @objc func goTosettings(){
      let storyboard = UIStoryboard(name:"Main", bundle:nil)
        let goToSettingsPage = storyboard.instantiateViewController(withIdentifier:"AppSettingsViewController") as! AppSettingsViewController
        
        self.navigationController?.pushViewController(goToSettingsPage, animated:false)
        
    }
    
    func callToViewModelForUIUpdate(){
        
        self.employeeViewModel =  UserViewModel()
        self.employeeViewModel.bindEmployeeViewModelToController = {
            DispatchQueue.main.async {
                self.animationLoaderView.isHidden = true
                self.updateDataSource()

            }
        }
    }
    
    func updateDataSource(){
        
        self.dataSource = userTableViewDataSource(cellIdentifier: "userTableViewCell", items: self.employeeViewModel.empData, configureCell: { (cell, evm, row) in
            cell.lbluserId.text = "Node Id: " + (evm.nodeId.description )
            cell.lbluserName.text = evm.fullName
            if let imgURL = evm.owner?.photoUrl{
                cell.userImg.imageFromServerURL(imgURL, placeHolder: nil)
            }
            cell.userImg.layer.cornerRadius = 25
            
            cell.favouriteBtn.tag = row
            if self.localData.contains(evm.nodeId){
                cell.favouriteBtn.setImage(UIImage(named:"favourite"), for:.normal)
            }else{
                cell.favouriteBtn.setImage(UIImage(named:"unfavourite"), for:.normal)
            }
            cell.favouriteBtn.addTarget(self, action: #selector(self.favUnfavData), for: .touchUpInside)
        })
        DispatchQueue.main.async {
            self.tableView.delegate = self
            self.tableView.dataSource = self.dataSource
            self.tableView.reloadData()
        }
    }
    
    ///Pagination Code
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height {
            if !isAPIAtLastItem{
                self.animationLoaderView.isHidden = false
                page += 1
                self.employeeViewModel.apiCallForPagination(page:page)
            }
        }
        
    }

    
    @objc func favUnfavData(_ sender:UIButton){
        var userData = self.employeeViewModel.empData[sender.tag]
        if userData.isFav{
            //Unfav code
            userData.isFav = false
            self.employeeViewModel.updateEmpValue(userData, sender.tag)
            guard let id = userData.id else { return }
            deleteData(id:Int16(truncatingIfNeeded:id))
        }else{
            //fav code
            userData.isFav = true
            self.employeeViewModel.updateEmpValue(userData, sender.tag)
            insertUserDataIntoDB(userData: userData)
            
        }
        self.tableView.reloadData()
        
    }
    
    
    func insertUserDataIntoDB(userData:UserData){
         context = appdelegate.persistentContainer.viewContext
             let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
             let userDetails = NSManagedObject(entity: entity!, insertInto: context)
        guard let id = userData.id else {return}
        
        userDetails.setValue(Int16(truncatingIfNeeded:id), forKey: "id")
        userDetails.setValue(userData.fullName, forKey: "name")
        userDetails.setValue(userData.nodeId, forKey: "node_id")
        userDetails.setValue(userData.owner?.photoUrl, forKey: "photoURL")
        
             do{
                 try context.save()
                fetchData()
             }catch{
                 debugPrint("Can't save")
             }
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
    
    //MARK:- FETCH DATA FROM THE CORE DATA
    func fetchData()
    {
        print("Fetching Data..")
        self.localData.removeAll()
        context = appdelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let dict = data.toDict()
                self.localData.append(dict["node_id"] as? String ?? "")
            }
        } catch {
            print("Fetching data Failed")
        }
    }
       
    
    
}



