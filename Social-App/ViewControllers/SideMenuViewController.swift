//
//  SideMenuViewController.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/3/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth


extension SideMenuViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sideMenuTitles.count + 1
        
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if  indexPath.row == 0  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSidemenuTableViewCell") as! ProfileSidemenuTableViewCell
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2
            
            
            if let user = Auth.auth().currentUser {
                cell.userNameLabel.text = user.displayName
                if let url:URL = user.photoURL {
                       cell.profileImageView.sd_setImage(with: url, placeholderImage: nil)
                }
                
            }
            return cell

        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell") as! SideMenuTableViewCell
        cell.cellTitleLabel.text = sideMenuTitles[indexPath.row - 1]
        return cell
    }
    
}

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 90
        }
        return 64
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == 1 {
            performSegue(withIdentifier: "MyStoriesSegue", sender: self)
        }
        
      
        
       
        
    }
    
    
    
}


class SideMenuViewController: UIViewController {
    
    let sideMenuTitles = ["My Stories"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressLogout(_ sender: Any) {
        Networking.sharedInstance.logout()
        
        
         self.dismiss(animated: false, completion: nil)
        
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "LogininNav")
//        self.present(controller, animated: true, completion: nil)
//
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setSigninRoot()
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
