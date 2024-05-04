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

class SaveMedicineViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var medicineImageView: UIImageView!
    @IBOutlet weak var medicineNameTF: UITextField!
    @IBOutlet weak var dosageTF: UITextField!
    @IBOutlet weak var mealTF: UITextField!
    @IBOutlet weak var dueDateTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextView!
    
    var datePicker: UIDatePicker?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        dueDateTF.inputView = datePicker

        medicineImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        medicineImageView.addGestureRecognizer(gestureRecognizer)
        let getGesture = UITapGestureRecognizer(target: self, action: #selector(gestureRecognize))
                view.addGestureRecognizer(getGesture)
        datePicker?.addTarget(self, action: #selector(getDate(uiDatePicker:)), for: .valueChanged)
       
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
        let storageReference = storage.reference()  //resimlerin kaydedilidği kaynak
        let mediaFolder = storageReference.child("media")
        
        if let data = medicineImageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil) { (storagemetadata, error) in
                if error != nil{
                    print(error?.localizedDescription)
                    self.errorAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Select new photo")
                }else{
                    imageReference.downloadURL { url, error in
                        if error == nil{
                            
                            let imageURL = url?.absoluteString
                            
                            print(imageURL)
                            
                            if let imageURL = imageURL{
                                let firestoreDatabase = Firestore.firestore()
                                let firestoreMedicine = ["imageurl" : imageURL, "description" : self.descriptionTF.text!, "medicineName": self.medicineNameTF.text! , "username": Auth.auth().currentUser!.email , "dosage": self.dosageTF.text!, "meal": self.mealTF.text!, "dueDate": self.dueDateTF.text!] as [String : Any]
                                firestoreDatabase.collection("Medicine").addDocument(data: firestoreMedicine) { (error) in
                                    if error != nil {
                                        self.errorAlert(titleInput: "Error", messageInput: error!.localizedDescription)
                                    }else{
                                        
                                    }
                        
                                }
                            }
                            
                            //collection oluşturulma
                            
                            
                            
                            
                        }
                    }
                }
            }
            
        }
        
        
    }
    
    
    func errorAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
