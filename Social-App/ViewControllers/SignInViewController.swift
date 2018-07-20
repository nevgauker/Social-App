//
//  SignInViewController.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/3/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit
import PopupDialog
import NVActivityIndicatorView



extension SignInViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        
        if textField === emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        
        if textField === passwordTextField {
            didPressSignIn(signInBtn)
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField === passwordTextField {
            let temp:CGFloat = self.view.frame.height - keyboardHeight
            if signInBtn.frame.origin.y +  signInBtn.frame.size.height > temp  {
                print("button is not on screen")
                let delta = (signInBtn.frame.origin.y +  signInBtn.frame.size.height) - temp
                scrollView.contentOffset.y = delta
                
            }
        }
        
    }
    
    
    
}

class SignInViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var errorLabel: UILabel!

    @IBOutlet weak var loader: NVActivityIndicatorView!
    
    var email = ""
    var password = ""
    
    var keyboardHeight:CGFloat = 0.0
    var forgotVC:ForgotPasswordViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.alpha = 0
        signInBtn.layer.cornerRadius = 5.0
        
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var size = scrollView.contentSize
        size.height+=100
        scrollView.contentSize = size
        UIView.animate(withDuration: 1.2) {
            self.scrollView.alpha = 1.0
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didPressSignInAnonymously(_ sender: Any) {
        loaderAnimation(start: true)
        Networking.sharedInstance.signInAnonymously(completion: {(success) -> Void in
            if success {
                DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    self.loaderAnimation(start: false)
                    appDelegate.setMainRoot()
                }
            }else {
                DispatchQueue.main.async {
                    self.loaderAnimation(start: false)
                }
            }
        })
    }
    
    
    @IBAction func didPressSignIn(_ sender: Any) {
        loaderAnimation(start: true)
        Networking.sharedInstance.signIn(email: email, password: password, completion: {(success,errorStr) -> Void in
            if success {
                
                DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                      self.loaderAnimation(start: false)
                    appDelegate.setMainRoot()
                }
                
            }else {
                DispatchQueue.main.async {
                    if let  str = errorStr {
                        self.errorLabel.text = str
                        self.errorLabel.isHidden = false
                    }
                    self.loaderAnimation(start: false)
                }
            }
        })
    }
    @IBAction func didPressForgotPassword(_ sender: Any) {
        self.forgotVC = ForgotPasswordViewController(nibName: "ForgotPasswordViewController", bundle: nil)
        let popup = PopupDialog(viewController: self.forgotVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        let buttonOne = CancelButton(title: "CANCEL", height: 50) {
            
        }
        let buttonTwo = DefaultButton(title: "SEND", height: 50) {
            if let email = self.forgotVC.emailTextField.text{
                Networking.sharedInstance.resetPassword(email: email, completion: {(success) -> Void in
                    if success {
                        DispatchQueue.main.async {
                            
                        }
                    }else {
                        
                    }
                })
            }
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])

        self.present(popup, animated: true, completion: nil)

    }
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        errorLabel.text = ""
        errorLabel.isHidden = true
        
        if textField === emailTextField {
            email = textField.text!
        }
        if textField === passwordTextField {
            password = textField.text!
        }
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
             self.keyboardHeight = keyboardRectangle.height
        }
    }
    
    
    func loaderAnimation(start:Bool) {
        if start {
            loader.startAnimating()
        }else {
            loader.stopAnimating()
        }
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
