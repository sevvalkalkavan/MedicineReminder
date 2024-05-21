//
//  SignUpViewController.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 27.04.2024.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var DateOfBirthTF: UITextField!
    var datePicker: UIDatePicker?
    
    var personalDaoRepo = PersonalDaoRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        DateOfBirthTF.inputView = datePicker
        
        let getGesture = UITapGestureRecognizer(target: self, action: #selector(gestureRecognize))
                view.addGestureRecognizer(getGesture)
        datePicker?.addTarget(self, action: #selector(getDate(uiDatePicker:)), for: .valueChanged)

        self.navigationController?.navigationBar.tintColor = UIColor.gray
        
        
        usernameTF.delegate = self
        passwordTF.delegate = self
        heightTF.delegate = self
        weightTF.delegate = self
        DateOfBirthTF.delegate = self
     
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    


    @objc func gestureRecognize(){
            view.endEditing(true)
        }
    @objc func getDate(uiDatePicker:UIDatePicker){
        let format = DateFormatter()
        format.dateFormat = "MM/dd/yyyy"
        let currentDate = format.string(from: uiDatePicker.date)
        DateOfBirthTF.text = currentDate
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        
        if usernameTF.text != "" && passwordTF.text != "" {
            
            Auth.auth().createUser(withEmail: usernameTF.text!, password: passwordTF.text!)
            {(authdataresult, error) in
                if error != nil {
                    self.errorAlert(titleInput: "Error", messageInput: error!.localizedDescription)
                }else{
                    print("Başarılı hesap oluşturuldu.")
                    if let name = self.usernameTF.text, let weight = self.weightTF.text, let height = self.heightTF.text , let dob = self.DateOfBirthTF.text {
                        self.personalDaoRepo.save(name: name, weight: weight, height: height, dob: dob)
                    }
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


extension SignUpViewController{
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
        textField.resignFirstResponder()
        return true
    }
}