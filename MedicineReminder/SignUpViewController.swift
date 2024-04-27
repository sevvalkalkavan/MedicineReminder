//
//  SignUpViewController.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 27.04.2024.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var DateOfBirthTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        
        if usernameTF.text != "" && passwordTF.text != "" {
            Auth.auth().createUser(withEmail: usernameTF.text!, password: passwordTF.text!)
            {(authdataresult, error) in
                if error != nil {
                    self.errorAlert(titleInput: "Error", messageInput: error!.localizedDescription)
                }else{
                    print("Başarılı hesap oluşturuldu.")
                    self.performSegue(withIdentifier: "toCalendarVC", sender: self)
                }
            
            }
        }else{
            errorAlert(titleInput: "Error", messageInput: "Empty email or password")
        }
        
    }
    
    
    func errorAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
