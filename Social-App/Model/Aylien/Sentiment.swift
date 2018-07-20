//
//  Sentiment.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/28/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit

class Sentiment: NSObject {
    
    var polarity = ""
    var subjectivity = ""
    var text = ""
    var polarity_confidence = ""
    var subjectivity_confidence = ""
    
    
    init(polarity:String, subjectivity:String,text:String,polarity_confidence:String,subjectivity_confidence:String) {
        self.polarity = polarity
        self.subjectivity = subjectivity
        self.text = text
        self.polarity_confidence = polarity_confidence
        self.subjectivity_confidence = subjectivity_confidence
    }
    
   

}
