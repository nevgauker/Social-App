//
//  Entities.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/28/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit

class Entities: NSObject {
    
    var text = ""
    var language = ""
    
    var entities:[String:Any] = [String:Any]()
    
    
    init(language:String, text:String,entities:[String:Any]) {
        self.language = language
        self.text = text
        //TBD  will set all entities data when needed to
    }

}
