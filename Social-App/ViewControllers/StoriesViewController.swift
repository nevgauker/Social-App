//
//  StoriesViewController.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/3/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SDWebImage
import PopupDialog


extension StoriesViewController: UITableViewDataSource {
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Networking.sharedInstance.posts.count
        
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        let post = Networking.sharedInstance.posts[indexPath.row]
        cell.titleLabel.text = post.title
        cell.postTextView.text = post.text
        cell.postTextView.layer.cornerRadius = 10
        cell.postTextView.layer.borderWidth = 1.0
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.width/2
        cell.userImageView.clipsToBounds = true
        cell.postTextView.alpha = 0.2
        //let num:String = String(post.postParts.count)
        
        let date = Date(timeIntervalSince1970: TimeInterval(post.created_at))
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.placeholderLabel.text = dateFormatterGet.string(from: date) //date.description // String(indexPath.row)   // num  + " more parts"
        
        
        Networking.sharedInstance.getUserPhotoUrl(uid:post.creator_uid, completion: {(photoUrl:String?) -> Void in
            if let urlStr = photoUrl  {
                cell.userImageView.sd_setImage(with: URL(string: urlStr), placeholderImage: nil)
            }
            
        })
        
        
        return cell
    }
    
    
    
}

extension StoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 220
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedPost = Networking.sharedInstance.posts[indexPath.row]
        performSegue(withIdentifier: "ContinuePostSegue", sender: self)
    }
    
    
//    private func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//
//        UIView.animate(withDuration: 1.0, animations: {
//            if let cell = cell as? PostTableViewCell {
//                cell.postTextView.alpha = 0.2
//            }
//        }, completion: {
//            (value: Bool) in
//
//        })
    
    
//    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        UIView.animate(withDuration: 1.0, animations: {
            if let cell = cell as? PostTableViewCell {
                cell.postTextView.alpha = 1.0
            }
        }, completion: {
            (value: Bool) in
          
        })

        if indexPath.row  >= Networking.sharedInstance.posts.count - 1 {

            posts_ref.queryLimited(toLast: 20).queryOrdered(byChild:"id").queryEnding(atValue: self.last_fetched_post_id).observeSingleEvent(of: .value, with: { snapshot in
                var newPosts:[Post] = [Post]()
                
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    
                    if snapshot.count == 0 {
                        return
                    }
                    for snap in snapshot {
                        if let postDict = snap.value as? [String :  AnyObject] {
                            let title = postDict["title"] as! String
                            let text = postDict["text"] as! String
                            let creator_uid = postDict["creator"] as! String
                            let id = postDict["id"] as! String
                            let created_at = postDict["created_at"] as! CLongLong
                            let parts: [[String:Any]]? =  postDict["postParts"] as? [[String:Any]]
                            
                            var needToAdd = true
                            
                            for cur in Networking.sharedInstance.posts {
                                
                                if cur.id == id {
                                    needToAdd = false
                                }
                            }
                            if needToAdd {
                                let post:Post = Post(id: id, title: title, text: text, creator_uid: creator_uid,created_at:created_at, parts: parts, postBackgroundImageUrl: nil)
                                if newPosts.count == 1 {
                                    self.last_fetched_post_id = post.id
                                    self.last_fetched_post_time = post.created_at
                                }
                                newPosts.insert(post, at: 0)
                            }
                        }
                    }
                  
                    
                    Networking.sharedInstance.posts.append(contentsOf: newPosts)
                    self.postsTableView.reloadData()
                }

              
                
                

            })

        }

    }
    

    
}

extension StoriesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool  {
        if let text = searchBar.text {
            filterText = text
            filterPosts()
        }
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == "" {
            //clear
            searchBar.resignFirstResponder()

            
        }
    }
    
}

class StoriesViewController: UIViewController {

    
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var posts_ref  = Database.database().reference().child("posts")
  //  var filteredPosts:[Post] = [Post]()
    var filterText = ""
    var last_fetched_post_id = ""
    var last_fetched_post_time:CLongLong = 0

    var limit = 20
    var selectedPost:Post?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stories"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        searchBar.setStyleColor(UIColor(red: 61/255, green: 70/255, blue: 248/255, alpha: 1.0)
            
)
        
    
//        MeaningCloud.sharedInstance.topics(txt: "I have a big house", completion: {(good:Bool) -> Void in
//
//
//        })
        
        
//        AylienAPI_networking.sharedInstance.combineCall(text: "i have a big house", completion: {(good:Bool) -> Void in
//            
//            
//        })
        
        
//         _ = posts_ref.queryOrderedByKey().queryLimited(toFirst: 1).observe(.value, with: { snapshot in
//            
//            print(snapshot)
//         })
        
      //  _ = posts_ref.queryLimited(toLast: 20).queryOrdered(byChild:"created_at").observe(.value, with: { (snapshot) in


        
       // _ = posts_ref.queryLimited(toLast: 20).queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in

        
        _ = posts_ref.queryLimited(toLast: 20).queryOrdered(byChild:"id").observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                Networking.sharedInstance.posts.removeAll()
                for snap in snapshot {
                    if let postDict = snap.value as? [String :  AnyObject] {
                        
                        let title = postDict["title"] as! String
                        let text = postDict["text"] as! String
                        let creator_uid = postDict["creator"] as! String
                        let id = postDict["id"] as! String
                        let created_at = postDict["created_at"] as! CLongLong
                        let parts: [[String:Any]]? =  postDict["postParts"] as? [[String:Any]]
                        let postBackgroundImageUrl = postDict["postBackgroundImageUrl"]
                        let post:Post = Post(id: id, title: title, text: text, creator_uid: creator_uid,created_at:created_at, parts: parts, postBackgroundImageUrl:postBackgroundImageUrl as? String )
                        Networking.sharedInstance.posts.insert(post, at: 0)
                        if Networking.sharedInstance.posts.count == 1 {
                            self.last_fetched_post_id = post.id
                            self.last_fetched_post_time = post.created_at
                        }
                        
                    }
                    
                }
                
            }
            
            self.postsTableView.reloadData()

            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
//
//        _ = posts_ref.queryOrdered(byChild: "created_at").observe(.value, with: { snapshot in
//
//
//            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
//                Networking.sharedInstance.posts.removeAll()
//                for snap in snapshot {
//                    if let postDict = snap.value as? [String :  AnyObject] {
//
//                        let title = postDict["title"] as! String
//                        let text = postDict["text"] as! String
//                        let creator_uid = postDict["creator"] as! String
//                        let id = postDict["id"] as! String
//                        let created_at = postDict["created_at"] as! CLongLong
//                        let parts: [[String:Any]]? =  postDict["postParts"] as? [[String:Any]]
//                        let postBackgroundImageUrl = postDict["postBackgroundImageUrl"]
//                        let post:Post = Post(id: id, title: title, text: text, creator_uid: creator_uid,created_at:created_at, parts: parts, postBackgroundImageUrl:postBackgroundImageUrl as? String )
//                        Networking.sharedInstance.posts.insert(post, at: 0)
//                        self.last_fetched_post_id = post.id
//
//                    }
//
//                }
//                self.filteredPosts.removeAll()
//                self.filteredPosts.append(contentsOf:Networking.sharedInstance.posts)
//
//            }
        
            
            
//            let postsDict = snapshot.value as? [String : AnyObject] ?? [:]
//
//            let keys = postsDict.keys
//
//            self.posts.removeAll()
//            for  key in keys {
//
//                 let postDict = postsDict[key] as? [String : AnyObject] ?? [:]
//
//                let title = postDict["title"] as! String
//                let text = postDict["text"] as! String
//                let creator_uid = postDict["creator"] as! String
//                let id = postDict["id"] as! String
//                let created_at = postDict["created_at"] as! CLongLong
//                let parts: [[String:Any]]? =  postDict["postParts"] as? [[String:Any]]
//
//                let post:Post = Post(id: id, title: title, text: text, creator_uid: creator_uid,created_at:created_at, parts: parts)
//                self.posts.append(post)
//                self.last_fetched_post_id = post.id
//            }


         //  self.postsTableView.reloadData()



      //  })
        
        
        

        
//        posts_ref.observe(.childAdded, with: { (snapshot) -> Void in
//            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
//
//            let title = postDict["title"] as! String
//            let text = postDict["text"] as! String
//            let creator_uid = postDict["creator"] as! String
//            let id = postDict["id"] as! String
//            let created_at = postDict["created_at"] as! String
//            let parts: [[String:Any]]? =  postDict["postParts"] as? [[String:Any]]
//
//            let post:Post = Post(id: id, title: title, text: text, creator_uid: creator_uid,created_at:created_at, parts: parts)
//
//            self.posts.append(post)
//
//            self.postsTableView.insertRows(at: [IndexPath(row: self.posts.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
//        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressAddNewPost(_ sender: Any) {
        if (Auth.auth().currentUser?.isAnonymous)! {
            let title = "Anonymous user"
            let message = "Sign up in order to write your stories!"
            let popup = PopupDialog(title: title, message: message, image: nil)
            
            let buttonOne = CancelButton(title: "CANCEL", dismissOnTap: true) {
            }
            let buttonTwo = DefaultButton(title: "OK", dismissOnTap: true) {
                Networking.sharedInstance.logout()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.setSigninRoot()
            }
            popup.addButtons([buttonOne, buttonTwo])
            self.present(popup, animated: true, completion: nil)
            
        }else {
            performSegue(withIdentifier: "NewPostSegue", sender: self)
        }
        
    }
    @IBAction func didPressSideMenu(_ sender: Any) {
        
        if (Auth.auth().currentUser?.isAnonymous)! {
            let title = "Anonymous user"
            let message = "Sign up in order to view your stories!"
            let popup = PopupDialog(title: title, message: message, image: nil)
            
            let buttonOne = CancelButton(title: "CANCEL", dismissOnTap: true) {
            }
            let buttonTwo = DefaultButton(title: "OK", dismissOnTap: true) {
               Networking.sharedInstance.logout()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.setSigninRoot()
            }
            popup.addButtons([buttonOne, buttonTwo])
            self.present(popup, animated: true, completion: nil)
        }else {
            performSegue(withIdentifier: "SideMenuSegue", sender: self)
        }
        
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "ContinuePostSegue" {
            let vc:NewPostViewController = segue.destination as! NewPostViewController
            vc.currentStata = State.Continue
            if let post = selectedPost {
                vc.currentPost = post

            }
        }
        if segue.identifier == "NewPostSegue" {
            let vc:NewPostViewController = segue.destination as! NewPostViewController
            vc.currentStata = State.New
        }
      
    }
    
    func filterPosts() {
//        filteredPosts.removeAll()
//
//        if filterText == "" {
//            filteredPosts.append(contentsOf:   Networking.sharedInstance.posts)
//        }else {
//            for post in  Networking.sharedInstance.posts {
//                if post.title.range(of:filterText) != nil {
//                    filteredPosts.append(post)
//                } else if post.text.range(of:filterText) != nil {
//                    filteredPosts.append(post)
//                }
//
//            }
//        }
//        postsTableView.reloadData()
        
    }
    

}
