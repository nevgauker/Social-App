//
//  PostView.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/13/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit
import FirebaseAuth

class PostView: UIView {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    
    
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var editBtn: UIButton!
    
    var postPart:PostPart!
    var post_id:String = ""
    var index = 0
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "PostView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
       
        
    }
    func setupData(postPart:PostPart,index:Int,post_id:String) {
        self.postPart = postPart
        self.index = index
        self.post_id = post_id
        
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
        
        if Auth.auth().currentUser?.uid == postPart.creator_uid {
            postTextView.backgroundColor = UIColor.white
            editBtn.isHidden  = false
            postTextView.isEditable = true
        }else {
              postTextView.backgroundColor = UIColor(red: 238/255.0, green: 230/255.0, blue: 255.0/255.0, alpha: 1.0)
            editBtn.isHidden = true
        }
        
        
        postTextView.text = postPart.text
        Networking.sharedInstance.getUserPhotoUrl(uid:postPart.creator_uid, completion: {(photoUrl:String?) -> Void in
            if let urlStr = photoUrl  {
                self.userImageView.sd_setImage(with: URL(string: urlStr), placeholderImage: nil)
            }
            
        })
        
        
    }
    
    @IBAction func didPressEditPostPart(_ sender: Any) {
        
        postTextView.resignFirstResponder()
        
        Networking.sharedInstance.updatePostPart(post_id: post_id, index: index, text: postTextView.text, completion: {(success) -> Void in
            
            if success {
                
            }else {
                
                
            }
            
        })
        
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
