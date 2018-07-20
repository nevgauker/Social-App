//
//  ProfileSidemenuTableViewCell.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/5/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit

class ProfileSidemenuTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
