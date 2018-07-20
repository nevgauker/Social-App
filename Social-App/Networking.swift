//
//  Networking.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/3/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import GoogleSignIn
import SwiftyJSON




class Networking: NSObject,GIDSignInUIDelegate {
    
    static let sharedInstance = Networking()
    
    let storage = Storage.storage()
    
    let db_ref = Database.database().reference()
    
    
    var posts:[Post] = [Post]()
    
    
    func uploadPostBackgroundImage(post_id:String,image:UIImage)->StorageUploadTask? {
            let storageRef = storage.reference()
            //let imageData: Data = UIImagePNGRepresentation(image)!
        
            let imageData = UIImageJPEGRepresentation(image, 0.4)!

        
        
            let fileName = "postBackground" + post_id + ".jpg"
            let profileImageRef = storageRef.child("images/postsBackgrounds/" + fileName)
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            let uploadTask = profileImageRef.putData(imageData, metadata: metaData,completion: { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                print(metadata)
                // let size = metadata.size
                
                profileImageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    self.db_ref.child("posts").child((post_id)).updateChildValues(["postBackgroundImageUrl" : downloadURL.absoluteString])
                    

                }
        })
        return uploadTask
 
    }
    
    
    
    func uploadProfieImage(image:UIImage)->StorageUploadTask? {
        
        let user = Auth.auth().currentUser
        if let user = user {
            let storageRef = storage.reference()
            let imageData: Data = UIImagePNGRepresentation(image)!
            let fileName = "profileImage" + user.uid + ".jpg"
            let profileImageRef = storageRef.child("images/" + fileName)
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            let uploadTask = profileImageRef.putData(imageData, metadata: metaData,completion: { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                print(metadata)
               // let size = metadata.size
                
                profileImageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.photoURL = downloadURL
                    changeRequest?.commitChanges { (error) in
                        if error == nil {
                            if let user:User = Auth.auth().currentUser {
                                
                                if let url:String = user.photoURL?.absoluteString{
                                    
                                    self.db_ref.child("users").child((user.uid)).setValue(["photoUrl" : url])
                                    
                                }
                                
                                
                            }
                            
                        }
                    }
                }
            })
            return uploadTask
        }
        return nil
    }
              
    
    func googleSignIn(completion: @escaping (Bool,String?) -> ()) {
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()


    }
    
    

    func signIn(email: String,password:String, completion: @escaping (Bool,String?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                 completion(true,nil)
            }else {
                let errorStr = error!.localizedDescription
                completion(false,errorStr)
            }
        }
    }
   
    func signInAnonymously(completion: @escaping (Bool) -> ()) {
        
        Auth.auth().signInAnonymously() { (authResult, error) in
            if  error == nil {
                completion(true)
            }else {
                completion(false)
            }
        }
    }
    
    func signUp(name: String, email:String,password:String, completion: @escaping (Bool) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error == nil {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges { (error) in
                    if error == nil {
                        if let user:User = Auth.auth().currentUser {
                            self.db_ref.child("users").child((user.uid)).setValue(["uid" : user
                                .uid, "name" : user.displayName])
                        }
                    }
                    completion(true)
                }
            }else {
                completion(false)

            }
        }
    }
    
    func logout() {
        do { try Auth.auth().signOut() }
        catch {}
    }
    
    func updatePost(post:Post,title:String,text:String)->String {
        let key = post.id
        self.db_ref.child("posts").child(key).updateChildValues(["title" : title, "text" : text])
        return key
    }
    func updatePostInsights(post_id:String,resposeJSON:JSON) {
        for (key,subJson):(String, JSON) in resposeJSON["results"] {
            let subDict = subJson.dictionary
            if subDict!["endpoint"] == "hashtags" {
                //manage hashtags
                
                if let hashtags:[String] = subDict!["result"]!["hashtags"].arrayObject as? [String] {
                    var tagsStr:String = ""
                    for tag in hashtags {
                        tagsStr += tag
                    }
                    self.db_ref.child("posts").child(post_id).updateChildValues(["hashtags" : tagsStr])
                }
                
            }
            if subDict!["endpoint"] == "summarize" {
                //manage hashtags
                
                if let sentences:[String] = subDict!["result"]!["sentences"].arrayObject as? [String] {
                    var sentencesStr:String = ""
                    for sentence in sentences {
                        sentencesStr += sentence
                    }
                    self.db_ref.child("posts").child(post_id).updateChildValues(["sentences" : sentencesStr])
                }
                
            }
            if subDict!["endpoint"] == "concepts" {
                //manage hashtags
                
                if let concepts:[String] = subDict!["result"]!["concepts"].arrayObject as? [String] {
                    var conceptsStr:String = ""
                    for concept in concepts {
                        conceptsStr += concept
                    }
                    self.db_ref.child("posts").child(post_id).updateChildValues(["concepts" : conceptsStr])
                }
                
            }
            if subDict!["endpoint"] == "entities" {
                //manage hashtags
                
                if let entities:[String: JSON] = subDict!["result"]!["entities"].dictionary {
                    
                    
                    if entities["location"] != nil {
                        if let location:[String] = entities["location"]!.arrayObject as? [String] {
                            var locationStr:String = ""
                            for loc in location {
                                locationStr += loc
                            }
                            self.db_ref.child("posts").child(post_id).updateChildValues(["location" : locationStr])
                        }
                    }
                    if entities["organization"] != nil {
                        if let organization:[String] = entities["organization"]!.arrayObject as? [String] {
                            var organizationStr:String = ""
                            for org in organization {
                                organizationStr += org
                            }
                            self.db_ref.child("posts").child(post_id).updateChildValues(["organization" : organizationStr])
                        }
                        
                    }
                    if entities["person"] != nil {
                        if let person:[String] = entities["person"]!.arrayObject as? [String] {
                            var personStr:String = ""
                            for per in person {
                                personStr += per
                            }
                            self.db_ref.child("posts").child(post_id).updateChildValues(["person" : personStr])
                        }
                    }
                    
                   
                }
                
            }
        }
    }

    
    func createNewPost(creator_uid:String,title:String,text:String)->String {
        
        let key = db_ref.child("posts").childByAutoId().key
        
//        let dateformatter = DateFormatter()
//        dateformatter.dateStyle = DateFormatter.Style.short
//        dateformatter.timeStyle = DateFormatter.Style.short
        let create_at =  ServerValue.timestamp()  //dateformatter.string(from: Date())
        
        self.db_ref.child("posts").child(key).setValue(["id": key, "title" : title, "text" : text, "creator" : creator_uid, "created_at" : create_at])
        return key
    }
    func createNewPostPart(creator_uid:String,text:String,post:Post, completion: @escaping (Bool) -> ()){
        let part_id = db_ref.child("posts").child(post.id).child("postParts").childByAutoId().key
        
        
        if post.postParts.count == 0{
            
            self.db_ref.child("posts").child(post.id).child("postParts").child("0").setValue(["id" : part_id,
                                                                                              "text" : text,"creator_uid" : creator_uid,"prev_id" : post.id])
    
            //first part
            }else {
        
            let lastPart = post.postParts.last
        self.db_ref.child("posts").child(post.id).child("postParts").child(String(post.postParts.count)).setValue(["id" : part_id, "creator_uid": creator_uid, "text" : text, "prev_id" : lastPart?.id])
    
        }
    
        completion(true)
        
        
    }
    
    func updatePostPart(post_id:String,index:Int,text:String, completion: @escaping (Bool) -> ()){
        self.db_ref.child("posts").child(post_id).child("postParts").child(String(index)).updateChildValues(["text" : text])
        completion(true)
    }
    
    
    
    func getUserPhotoUrl(uid:String,completion: @escaping (String?) -> ()) {

        db_ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let photoUrl = value?["photoUrl"] as? String ?? ""
            completion(photoUrl)
        }) { (error) in
            print(error.localizedDescription)
            completion(nil)
        }
    }
    
    func resetPassword(email:String,completion: @escaping (Bool) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { error in
            if error == nil {
                completion(true)
            }else {
                completion(false)
            }
        })
    }
    
    //MARK: mGIDSignInUIDelegate
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                return
            }
            // User is signed in
            // ...
        }
        // ...
    }
    
    
    func test_create_three_hundred() {
        for i in 0..<300 {
            
            let title = "title  " + String(i)
            let text  = String(i) + String(i) + String(i) + String(i) + String(i) + String(i) + "text text text texttext texttext texttext texttext texttext texttext texttext texttext text"
            if let user = Auth.auth().currentUser {
                let id = Networking.sharedInstance.createNewPost(creator_uid: user.uid, title: title, text: text)
                print(id)
            }
        }
    }
    
    
    
    
    
}
