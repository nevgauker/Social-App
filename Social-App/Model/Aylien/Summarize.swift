//
//  Summarize.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/28/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit

class Summarize: NSObject {
    
    var sentences = ""
    var text = ""
    
    init(sentences:String, text:String) {
        self.sentences = sentences
        self.text = text
    }

}
