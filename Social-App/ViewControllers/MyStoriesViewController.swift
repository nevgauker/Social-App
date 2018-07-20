//
//  MyStoriesViewController.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/26/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit
import FirebaseAuth

extension MyStoriesViewController: UITableViewDataSource {
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myStories.count
        
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        let post = myStories[indexPath.row]
        cell.titleLabel.text = post.title
        cell.postTextView.text = post.text
        cell.postTextView.layer.cornerRadius = 10
        cell.postTextView.layer.borderWidth = 1.0
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.width/2
        cell.userImageView.clipsToBounds = true
        
        //let num:String = String(post.postParts.count)
        
        let date = Date(timeIntervalSince1970: TimeInterval(post.created_at))
        
        cell.placeholderLabel.text = date.description // String(indexPath.row)   // num  + " more parts"
        
        
        Networking.sharedInstance.getUserPhotoUrl(uid:post.creator_uid, completion: {(photoUrl:String?) -> Void in
            if let urlStr = photoUrl  {
                cell.userImageView.sd_setImage(with: URL(string: urlStr), placeholderImage: nil)
            }
            
        })
        
        
        return cell
    }
    
    
    
}

extension MyStoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedPost = myStories[indexPath.row]
        performSegue(withIdentifier: "ContinuePostSegue", sender: self)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
    
    
}

class MyStoriesViewController: UIViewController {
    @IBOutlet weak var myStoriesTableView: UITableView!
    
    var myStories:[Post] = [Post]()
    var selectedPost:Post?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Stories"
        
        for post in Networking.sharedInstance.posts {
            
            if let myUser = Auth.auth().currentUser {
                if post.creator_uid == myUser.uid {
                    myStories.append(post)
                }
                
            }
            
          
            
        }
        myStoriesTableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
      
        
    }
    

}
