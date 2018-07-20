//
//  SideMenuTableViewCell.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/3/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var leftIconImageView: UIImageView!
    
    @IBOutlet weak var cellTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    
}
