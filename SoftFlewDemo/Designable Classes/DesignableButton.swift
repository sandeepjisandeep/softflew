//
//  DesignableButton.swift
//  SoftFlewDemo
//
//  Created by Sandeep Srivastava on 26/01/23.
//  Copyright © 2023 Sandeep. All rights reserved.
//

import Foundation
import UIKit

import UIKit

@IBDesignable class DesignableButton: UIButton {

    @IBInspectable var borderWidth:CGFloat = 0.0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor:UIColor = UIColor.clear{
        didSet{
            
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var cornerRadius:CGFloat = 0.0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
}
