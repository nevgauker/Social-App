//
//  ForgotPasswordViewController.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/13/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit

extension ForgotPasswordViewController : UITextFieldDelegate {
    
    
    
}

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        view.backgroundColor = UIColor.clear
//        containerView.layer.cornerRadius = 10.0
//        containerView.layer.borderColor = UIColor.black.cgColor
//        containerView.layer.borderWidth = 1.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressSend(_ sender: Any) {
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
