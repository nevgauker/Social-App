//
//  PostPart.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/12/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit

class PostPart: NSObject {
    var id:String = ""
    var text:String = ""
    var creator_uid=""
    var prev_id = ""
    
    
    init(id:String,text:String,creator_uid:String,prev_id:String ) {
        self.id = id
        self.text = text
        self.creator_uid = creator_uid
        self.prev_id = prev_id
        
    }
    
}
