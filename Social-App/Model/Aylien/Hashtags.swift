//
//  Hashtags.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/28/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit

class Hashtags: NSObject {
    
    var text = ""
    var language = ""
    
    var hashtags:[String] = [String]()
    
    
    init(language:String, text:String,hashtags:[String]) {
        self.language = language
        self.text = text
        self.hashtags.append(contentsOf: hashtags)
    }
    
    

}
