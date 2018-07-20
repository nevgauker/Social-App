//
//  Concepts.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/28/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit

class Concepts: NSObject {
    
    
    var text = ""
    var language = ""
    
    var concepts:[String:Any] = [String:Any]()
    
    
    init(language:String, text:String,concepts:[String:Any]) {
        self.language = language
        self.text = text
        //TBD  will set all concepts data when needed to
    }
    
        
    
    
    
    

}
