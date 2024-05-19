//
//  LogInViewController.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 27.04.2024.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.gray
        
    }
    
    @IBAction func LogInButton(_ sender: Any) {
        
        
        if usernameTF.text != "" && passwordTF.text != "" {
            
            Auth.auth().signIn(withEmail: usernameTF.text!, password: passwordTF.text!){(authdataresult, error) in
                if error != nil {
                    self.errorAlert(titleInput: "Error", messageInput: error!.localizedDescription)
                }else{
                   print("Başarılı giriş")
                    self.performSegue(withIdentifier: "toCalendarVC", sender: self)
                }
            
            }
            
        }else{
            errorAlert(titleInput: "Error", messageInput: "Empty")
        }
        
        
    }
    
    func errorAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
