//
//  PostTableViewCell.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/5/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
