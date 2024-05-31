//
//  LogInViewController.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 27.04.2024.
//

import UIKit
import Firebase

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var loginViewModel = LogInviewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.gray
        
        usernameTF.delegate = self
        passwordTF.delegate = self
     
        
      
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gestureRecognize))
                view.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    @objc func gestureRecognize(){
            view.endEditing(true)
        }
    @IBAction func LogInButton(_ sender: Any) {
        
        
        if usernameTF.text != "" && passwordTF.text != "" {
            
            Auth.auth().signIn(withEmail: usernameTF.text!, password: passwordTF.text!){(authdataresult, error) in
                if error != nil {
                    self.loginViewModel.errorAlert(titleInput: "Error", messageInput: error!.localizedDescription, viewController: self)
                }else{
                   print("Başarılı giriş")
                    self.performSegue(withIdentifier: "toCalendarVC", sender: self)
                }
            
            }
            
        }else{
            loginViewModel.errorAlert(titleInput: "Error", messageInput: "Empty", viewController: self)
        }
        
        
    }
    
   
}


extension LogInViewController{
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTF {
            passwordTF.becomeFirstResponder()
        } else if textField == passwordTF {
            textField.resignFirstResponder()
        }
        return true
    }
}
