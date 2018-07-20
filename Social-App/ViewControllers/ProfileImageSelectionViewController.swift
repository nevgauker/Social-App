//
//  ProfileImageSelectionViewController.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/3/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit
import FirebaseStorage

extension ProfileImageSelectionViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImageView.image = image
        dismiss(animated:true, completion: nil)
        
    }
    
}
extension ProfileImageSelectionViewController: UINavigationControllerDelegate {
    
}


class ProfileImageSelectionViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func didPressImage(_ sender: Any) {
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
    
        })
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(deviceAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func didPressDone(_ sender: Any) {
        let resizedImage = profileImageView.image?.resize(toTargetSize: CGSize(width: 100, height: 100))
        if let uploadTask = Networking.sharedInstance.uploadProfieImage(image: resizedImage!) {
            _ = uploadTask.observe(.progress) { snapshot in
                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                    / Double(snapshot.progress!.totalUnitCount)
                print(percentComplete)
            }
            _ = uploadTask.observe(.success) { snapshot in
                // Upload completed successfully
                DispatchQueue.main.async {
                    self.imageUploadCompleted()
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
    
    
    func imageUploadCompleted() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setMainRoot()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
