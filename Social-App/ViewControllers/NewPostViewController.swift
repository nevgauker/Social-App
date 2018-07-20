//
//  NewPostViewController.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/3/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
import PopupDialog
import FirebaseStorage

extension NewPostViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        backgroundImageView.image = image
        
        UIView.animate(withDuration: 1.0) {
            self.scrollView.backgroundColor = UIColor.clear
        }

        
        dismiss(animated:true, completion: nil)
        
    }
    
}
extension NewPostViewController: UINavigationControllerDelegate {
    
}

extension NewPostViewController:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        postText = textView.text
        placeholderLabel.isHidden = !(textView.text.count == 0)
        postBtn.isEnabled = (postText.count > 0) && (postTitle.count > 0)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
          placeholderLabel.isHidden  = true

    }
    
    
    
}
extension NewPostViewController:UITextFieldDelegate {
    
}

enum State {
    case New
    case Continue
}



class NewPostViewController: UIViewController {

    var postTitle = ""
    var postText = ""
    var user:User?
    var currentStata:State = State.New
    var postPartsViews:[PostView] = [PostView]()
    
    let  scrollOffset:CGFloat = 400
    
    @IBOutlet weak var postPartsContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var postPartsContainer: UIView!
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var continueView: UIView!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var userDisplayNameLabel: UILabel!
    
    @IBOutlet weak var postBtn: UIButton!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var postTextView: UITextView!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBOutlet weak var backgroundImageView: UIImageView!

    
    var currentPost:Post?
    
    var postContinue:PostContinueViewController!
    
    var post_parts_ref  = Database.database().reference()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        postTextView.clipsToBounds = true

        postTextView.layer.borderWidth = 1.0
        postTextView.layer.cornerRadius = 10.0
        continueBtn.layer.cornerRadius = 10.0
        postView.backgroundColor = UIColor.clear
       
        
        if let the_post = currentPost {
            
            if the_post.postBackgroundImageUrl != "" {
                self.backgroundImageView.sd_setImage(with: URL(string:  (self.currentPost?.postBackgroundImageUrl)!), placeholderImage: nil)
                self.scrollView.backgroundColor = UIColor.clear
                
                
                
                
            }
            
            
            post_parts_ref = Database.database().reference().child("posts").child(the_post.id).child("postParts")
            post_parts_ref.observe(.childAdded, with: { (snapshot) -> Void in
                let postPartDict = snapshot.value as? [String : AnyObject] ?? [:]
                let id = postPartDict["id"] as! String
                let text = postPartDict["text"] as! String
                let creator_uid = postPartDict["creator_uid"] as! String
                let prev_id = postPartDict["prev_id"] as! String
                let newPostPart:PostPart = PostPart(id: id, text: text, creator_uid: creator_uid, prev_id: prev_id)
                if self.currentPost != nil {
                    
                    self.currentPost?.postParts.append(newPostPart)
                    DispatchQueue.main.async {
                        self.setCurrectPostIfNeeded()
                    }
                }
            })
        }else {
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
            longPressRecognizer.minimumPressDuration = 2.0
            self.scrollView.addGestureRecognizer(longPressRecognizer)
        }
        currentPost?.postParts.removeAll()
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.size.width/2
        userProfileImageView.clipsToBounds = true
        user = Auth.auth().currentUser
        userDisplayNameLabel.text = user?.displayName
        postBtn.isEnabled = false
        continueView.isHidden = true
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //test_create_one_hundred()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCurrectPostIfNeeded()

        //postTextView.layer.cornerRadius = 1.0
       // postTextView.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }
    
    override func viewDidLayoutSubviews() {
        
        
//        var height:CGFloat = self.postView.frame.height + self.continueView.frame.size.height
//        height += self.postPartsContainerHeight.constant + scrollOffset
//        let width:CGFloat  = self.postView.frame.size.width
//
//
//        self.scrollView.contentSize = CGSize(width: width, height: height)
//
        
        //scrollView.setContentViewSize()
        
        
//        var contentRect = CGRect.zero
//
//        for view in scrollView.subviews {
//            contentRect = contentRect.union(view.frame)
//        }
//        scrollView.contentSize = contentRect.size
        
        
//
       var size  = scrollView.contentSize
       size.height = CGFloat(postPartsViews.count) * 200
        size.height += postView.frame.size.height
        size.height += continueView.frame.size.height
        
        size.height += scrollOffset
        size.width  = postView.frame.size.width
        scrollView.contentSize = size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
  
    @objc func longPressed(_ sender: UIGestureRecognizer){

    //func longPressed(sender: UILongPressGestureRecognizer)
    //{
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        })
        
        let deviceAction = UIAlertAction(title: "From the device", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        })
        
        let resetAction = UIAlertAction(title: "Default background", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.backgroundImageView.image = nil
            self.scrollView.backgroundColor = UIColor(red: 61/255, green: 70/255, blue: 248/255, alpha: 1.0)
          
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(deviceAction)
        if backgroundImageView.image != nil {
            optionMenu.addAction(resetAction)

        }
        optionMenu.addAction(cancelAction)

        
        self.present(optionMenu, animated: true, completion: nil)
    }
    

    @IBAction func didPressContinue(_ sender: Any) {
        
        
        if (Auth.auth().currentUser?.isAnonymous)! {
            let title = "Anonymous user"
            let message = "Sign up in order to continue the story!"
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
            
            
            
            self.postContinue = PostContinueViewController(nibName: "PostContinueViewController", bundle: nil)
            
            let popup = PopupDialog(viewController: self.postContinue, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
            let buttonOne = CancelButton(title: "CANCEL", height: 50) {
                
            }
            let buttonTwo = DefaultButton(title: "SEND", height: 50) {
                let text = self.postContinue.text
                Networking.sharedInstance.createNewPostPart(creator_uid: (Auth.auth().currentUser?.uid)!, text: text, post: self.currentPost!,completion: {(success) -> Void in
                    
                    if success {
                        
                    }else {
                        
                        
                    }
                    
                })
                
            }
            
            popup.addButtons([buttonOne, buttonTwo])
            
            self.present(popup, animated: true, completion: nil)
            
        }
        
        
       // Networking.sharedInstance.createNewPostPart(creator_uid: (Auth.auth().currentUser?.uid)!, text: "sdfdfdsffsf", post: currentPost!)
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didPressPost(_ sender: Any) {
        if let current = self.currentPost {
            updatePost(post: current, title: postTitle, text: postText)
        }else {
            newPost(title: postTitle, text: postText)
        }
        self.dismiss(animated: true, completion: nil)

    }
    func updatePost(post:Post, title:String, text:String) {
        let post_id = Networking.sharedInstance.updatePost(post: post, title: title, text: text)
        print(post_id)
    }
    func newPost(title:String,text:String) {
           let user = Auth.auth().currentUser
            if let user = user {
                let post_id = Networking.sharedInstance.createNewPost(creator_uid: user.uid, title: title, text: text)
                uploadPostBackgroundIfNeeded(post_id:post_id)
                insights(text: text, post_id: post_id)
        }
    }
    
    func insights(text:String,post_id:String) {
        
        AylienAPI_networking.sharedInstance.combineCall(text: text, post_id:post_id, completion: {(good:Bool) -> Void in


        })
        
    }
        
        
     @objc func textFieldDidChange(_ textField: UITextField) {
        postTitle = textField.text!
        postBtn.isEnabled = (postText.count > 0) && (postTitle.count > 0)

    }
    
    func uploadPostBackgroundIfNeeded(post_id:String)  {
        
        if let backgroundImage = backgroundImageView.image {
            if let uploadTask = Networking.sharedInstance.uploadPostBackgroundImage(post_id:post_id, image: backgroundImage) {
                _ = uploadTask.observe(.progress) { snapshot in
                    let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                        / Double(snapshot.progress!.totalUnitCount)
                    print(percentComplete)
                }
                _ = uploadTask.observe(.success) { snapshot in
                    // Upload completed successfully
                    DispatchQueue.main.async {
                        
                    }
                }
                
                _ = uploadTask.observe(.failure) { snapshot in
                    if let error = snapshot.error as NSError? {
                        switch (StorageErrorCode(rawValue: error.code)!) {
                        case .objectNotFound:
                            // File doesn't exist
                            break
                        case .unauthorized:
                            // User doesn't have permission to access file
                            break
                        case .cancelled:
                            // User canceled the upload
                            break
                            
                            /* ... */
                            
                        case .unknown:
                            // Unknown error occurred, inspect the server response
                            break
                        default:
                            // A separate error occurred. This is a good place to retry the upload.
                            break
                        }
                    }
                }
            }
            
            
            
        }
        
        
    }
    
    
    func setCurrectPostIfNeeded() {
        if let post = currentPost {
            
            
            
            if post.postParts.count > 0 {
                postPartsContainer.isHidden = false
                
                for subview in postPartsContainer.subviews {
                    if subview.isKind(of: PostView.self) {
                        subview.removeFromSuperview()
                    }
                    
                }
                for  i in 0..<post.postParts.count {
                    let postView:PostView = PostView.instanceFromNib() as! PostView
                    postView.postTextView.layer.borderWidth = 1.0
                    postView.postTextView.layer.cornerRadius = 10.0
                    var rect = postView.frame
                    
                    rect.size.width = self.view.frame.size.width
                    rect.origin.y = postView.frame.size.height * CGFloat(i)
                    postView.frame = rect
                    postView.setupData(postPart: post.postParts[i],index:i,post_id:post.id)
                    postPartsViews.append(postView)
                    postView.backgroundColor = UIColor.clear
                    postPartsContainer.addSubview(postView)
                
                }
                postPartsContainerHeight.constant =  CGFloat(Double(post.postParts.count) *  Double(200/*postPartsViews[0].frame.size.height*/))
                
                
                view.layoutIfNeeded()

            }
            
            let text = post.text
            let title = post.title

            postTextView.text = text
            titleTextField.text = title
            
            postText = text
            postTitle = title
            
            
            postTextView.isEditable = false
            postBtn.isHidden = true
            continueView.isHidden = false
            placeholderLabel.isHidden = true
            titleTextField.isEnabled = false
            
            if post.creator_uid == Auth.auth().currentUser?.uid {
                //edit mode
                postBtn.isHidden = false
                postBtn.setTitle("Update", for: .normal)
                postTextView.isEditable = true
                titleTextField.isEnabled = true
            }
            
            
            Networking.sharedInstance.getUserPhotoUrl(uid:post.creator_uid, completion: {(photoUrl:String?) -> Void in
                if let urlStr = photoUrl  {
                    self.userProfileImageView.sd_setImage(with: URL(string: urlStr), placeholderImage: nil)
                }
                
            })
        }else {
            Networking.sharedInstance.getUserPhotoUrl(uid:(Auth.auth().currentUser?.uid)!, completion: {(photoUrl:String?) -> Void in
                if let urlStr = photoUrl  {
                    self.userProfileImageView.sd_setImage(with: URL(string: urlStr), placeholderImage: nil)
                }
                
            })
            
            
            
        }
        
    }
//    func addPostPartToView(postPart:PostPart){
//        let postPartView:PostView = PostView.instanceFromNib() as! PostView
//        postPartView.setupData(postPart: postPart)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
