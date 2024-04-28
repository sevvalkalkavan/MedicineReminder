//
//  SaveMedicineViewController.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 28.04.2024.
//

import UIKit
import FirebaseStorage

class SaveMedicineViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var medicineImageView: UIImageView!
    @IBOutlet weak var medicineNameTF: UITextField!
    @IBOutlet weak var dosageTF: UITextField!
    @IBOutlet weak var mealTF: UITextField!
    @IBOutlet weak var dueDateTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        medicineImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        medicineImageView.addGestureRecognizer(gestureRecognizer)
       
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
