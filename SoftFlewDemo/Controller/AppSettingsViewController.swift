//
//  AppSettingsViewController.swift
//  SoftFlewDemo
//
//  Created by Sandeep Srivastava on 28/01/23.
//  Copyright © 2023 Sandeep. All rights reserved.
//

import UIKit

class AppSettingsViewController: UIViewController {

    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var Languageswitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLanguage()
        Languageswitch.isOn = userdefault.bool(forKey: UserDefaultKeys.isdefaultLanguageON.rawValue)
        // Do any additional setup after loading the view.
    }
    
    func changeLanguage(){
        if userdefault.bool(forKey: UserDefaultKeys.isdefaultLanguageON.rawValue){
            lblTitle.text = "SettingsTitleKey".localizableString(loc: "en")
            lblLanguage.text = "LanguageLabelKey".localizableString(loc: "en")
            navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "CancelKeys".localizableString(loc: "en"), style: .plain, target: self, action: #selector(cancelBtn))
        }else{
            lblTitle.text = "SettingsTitleKey".localizableString(loc: "ar")
            lblLanguage.text = "LanguageLabelKey".localizableString(loc: "ar")
            navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "CancelKeys".localizableString(loc: "ar"), style: .plain, target: self, action: #selector(cancelBtn))
        }
    }
    
    @objc func cancelBtn(){
        self.navigationController?.popViewController(animated:true)
    }

    @IBAction func languageSwitch(_ sender: Any) {
        if Languageswitch.isOn {
            userdefault.set(true, forKey: UserDefaultKeys.isdefaultLanguageON.rawValue)
        }else{
            userdefault.set(false, forKey: UserDefaultKeys.isdefaultLanguageON.rawValue)
        }
        changeLanguage()
    }
    

}
