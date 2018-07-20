//
//  NotificationsViewController.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/3/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit
import FirebaseDatabase


extension NotificationsViewController: UITableViewDataSource {
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notifications.count
        
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotoficationTableViewCell") as! NotoficationTableViewCell
        return cell
    }
    
    
    
}

extension NotificationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
}


class NotificationsViewController: UIViewController {

    
    var notifications:[Notification]  = [Notification]()
    var notifications_ref  = Database.database().reference().child("notifications")

    @IBOutlet weak var notificationsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        notifications_ref.observe(.childAdded, with: { (snapshot) -> Void in
            let notificationDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            self.notificationsTableView.insertRows(at: [IndexPath(row: self.notifications.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
