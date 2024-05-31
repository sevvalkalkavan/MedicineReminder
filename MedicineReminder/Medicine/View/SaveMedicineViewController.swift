//
//  SaveMedicineViewController.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 28.04.2024.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseFirestore

class SaveMedicineViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var medicineImageView: UIImageView!
    @IBOutlet weak var medicineNameTF: UITextField!
    @IBOutlet weak var dosageTF: UITextField!
    @IBOutlet weak var mealTF: UITextField!
    @IBOutlet weak var dueDateTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextView!
    
    var saveViewModel = SaveMedicineViewModel()
    
    var datePicker: UIDatePicker?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        dueDateTF.inputView = datePicker
        
        descriptionTF.delegate = self
        medicineNameTF.delegate = self
        dosageTF.delegate = self
        mealTF.delegate = self
        dueDateTF.delegate = self

        medicineImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        medicineImageView.addGestureRecognizer(gestureRecognizer)
        let getGesture = UITapGestureRecognizer(target: self, action: #selector(gestureRecognize))
                view.addGestureRecognizer(getGesture)
        datePicker?.addTarget(self, action: #selector(getDate(uiDatePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gestureRecognize))
        view.addGestureRecognizer(tapGesture)
    
       
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
        dueDateTF.text = currentDate
    }
    @objc func selectImage(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary //uygulama canlıya alındığı zaman camera olarak değiştirilecek
        present(pickerController, animated: true, completion: nil)
        
    }

    //media seçildikten sonra olacaklar
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        medicineImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")

        if let data = medicineImageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")

            imageReference.putData(data, metadata: nil) { (storagemetadata, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.errorAlert(titleInput: "Error", messageInput: error.localizedDescription)
                    return
                } else {
                    imageReference.downloadURL { url, error in
                        if let error = error {
                            print(error.localizedDescription)
                            self.errorAlert(titleInput: "Error", messageInput: error.localizedDescription)
                            return
                        }
                        
                        if let imageURL = url?.absoluteString {
                            if let name = self.medicineNameTF.text,
                               let dosage = self.dosageTF.text,
                               let meal = self.mealTF.text,
                               let time = self.dueDateTF.text,
                               let description = self.descriptionTF.text {
                               
                                self.saveViewModel.saveMedicine(imageurl: imageURL, description: description, medicineName: name, dosage: dosage, meal: meal, dueDate: time)  
                                
                                print("Medicine saved successfully.")
                                
                            }
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        } else {
            self.errorAlert(titleInput: "Error", messageInput: "Image data could not be processed.")
        }
    }
    
    func errorAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension SaveMedicineViewController{
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0, descriptionTF.isFirstResponder {
                           self.view.frame.origin.y -= keyboardSize.height
                       }
        }
    }
    
   
        
        @objc func keyboardWillHide(notification: NSNotification) {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
        
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField == descriptionTF {
                if self.view.frame.origin.y != 0 {
                    self.view.frame.origin.y = 0
                }
            }
        }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == medicineNameTF {
            dosageTF.becomeFirstResponder()
        } else if textField == dosageTF {
            mealTF.becomeFirstResponder()
        } else if textField == mealTF {
            dueDateTF.becomeFirstResponder()
        } else if textField == dueDateTF {
            descriptionTF.resignFirstResponder()
        }else if textField == descriptionTF {
            textField.resignFirstResponder()
        }
        return true
    }
}
