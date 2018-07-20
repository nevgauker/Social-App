//
//  SignUpViewController.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/3/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


extension SignUpViewController :UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        
        if textField === nameTextField {
            emailTextField.becomeFirstResponder()
        }
        if textField === emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField === passwordTextField {
            didPressBack(signupBtn)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField === passwordTextField {
            let temp:CGFloat = self.view.frame.height - keyboardHeight
            if signupBtn.frame.origin.y +  signupBtn.frame.size.height > temp  {
                print("button is not on screen")
                let delta = (signupBtn.frame.origin.y +  signupBtn.frame.size.height) - temp
                scrollView.contentOffset.y = delta
                
            }
        }
        
    }
    
    
    
}

class SignUpViewController: UIViewController {
    
    var keyboardHeight:CGFloat = 0.0

    var email = ""
    var password = ""
    var name = ""
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainIcon: UIImageView!

    @IBOutlet weak var loader: NVActivityIndicatorView!

    
    @IBOutlet weak var signupBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.alpha = 0
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        signupBtn.layer.cornerRadius = 5.0
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)


        
        UIView.animate(withDuration: 0.8) {
            self.scrollView.alpha = 1.0
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var size = scrollView.contentSize
        size.height+=100
        scrollView.contentSize = size
        
        mainIcon.shake()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didPressSignUp(_ sender: Any) {
        loaderAnimation(start: true)
        Networking.sharedInstance.signUp(name: name, email: email, password: password, completion: {(success) -> Void in
            if success {
                DispatchQueue.main.async {
                    self.loaderAnimation(start: false)
                    self.performSegue(withIdentifier: "ImageSelectionSegue", sender: self)
                }
            }else {
                DispatchQueue.main.async {
                    self.loaderAnimation(start: false)
                }
            }
        })
    }
    
    @IBAction func didPressBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {

        if textField === nameTextField {
            name = textField.text!
        }
        if textField === passwordTextField {
            password = textField.text!
        }
        if textField === emailTextField {
            email = textField.text!
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
