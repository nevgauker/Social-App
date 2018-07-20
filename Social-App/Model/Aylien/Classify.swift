//
//  Classify.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/28/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit

class Classify: NSObject {
    
    var text = ""
    var language = ""
    
    var categories:[[String : Any]] = [[String : Any]]()
    
    
    init(language:String, text:String,categories:[String]) {
        self.language = language
        self.text = text
        //TBD  will set all categories data when needed to

       
    }

}
