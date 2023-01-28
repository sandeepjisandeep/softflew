//
//  userTableViewCell.swift
//  SoftFlewDemo
//
//  Created by Sandeep Srivastava on 26/01/23.
//  Copyright © 2023 Sandeep. All rights reserved.
//

import UIKit

class userTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundStackview: UIStackView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var lbluserName: UILabel!
    @IBOutlet weak var lbluserId: UILabel!
    @IBOutlet weak var favouriteBtn: DesignableButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
