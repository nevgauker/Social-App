//
//  Post.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/4/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit
import FirebaseAuth

class Post: NSObject {
    
    var id:String = ""
    var title:String = ""
    var text:String = ""
    var creator_uid=""
    var created_at:CLongLong
    var postBackgroundImageUrl = ""
    
    var postParts:[PostPart] = [PostPart]()
    
    init(id:String, title:String,text:String,creator_uid:String,created_at:CLongLong, parts:[[String : Any]]?,postBackgroundImageUrl:String?) {
            self.id = id
            self.title = title
            self.text = text
            self.creator_uid = creator_uid
            self.created_at = created_at
        
        if let backgroundUrl = postBackgroundImageUrl {
            self.postBackgroundImageUrl = backgroundUrl
        }
            if let current_parts = parts {
                for part in current_parts {
                    let partObject:PostPart = PostPart(id: part["id"] as! String, text: part["text"] as! String, creator_uid: part["creator_uid"] as! String, prev_id: part["prev_id"] as! String)
                    postParts.append(partObject)
                }
            }
    }

}
