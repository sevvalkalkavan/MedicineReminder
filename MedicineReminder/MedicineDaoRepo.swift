////
////  MedicineDaoRepo.swift
////  MedicineReminder
////
////  Created by Şevval Kalkavan on 5.05.2024.
////
//
//import Foundation
//import FirebaseFirestore
//import RxSwift
//class MedicineDaoRepo{
//    var medicineList = BehaviorSubject<[Medicine]>(value: [Medicine]())
//    var collectionMedicine = Firestore.firestore().collection("MedicineCollection")
//    
////    func saveMedicine(medicineImage: String, medicineName: String, medicineDosage: String, medicineMeal: String, medicineDate: String, medicineDescription: String){
////        let new: [String:Any] = ["medicineImage": ]
////    }
//    func saveMedicine(medicineImage: String, medicineName: String, medicineDosage: String, medicineMeal: String, medicineDate: String, medicineDescription: String){
//        let newDocumentRef = collectionMedicine.document() // Generate a new document reference
//        let data: [String:Any] = [
//            "medicineImage": medicineImage,
//            "medicineName": medicineName,
//            "medicineDosage": medicineDosage,
//            "medicineMeal": medicineMeal,
//            "medicineDate": medicineDate,
//            "medicineDescription": medicineDescription
//        ]
//        newDocumentRef.setData(data) { error in
//            if let error = error {
//                print("Error adding document: \(error)")
//            } else {
//                print("Document added with ID: \(newDocumentRef.documentID)")
//            }
//        }
//    }
//    
//    
//    func loadMedicine(){
//        collectionMedicine.addSnapshotListener{ snapshot, error in
//            var list = [Medicine]()
//            if let documents = snapshot?.documents{
//                for document in documents{
//                    let data = document.data()
//                    let documentId = document.documentID
//                   
//                    
//                    if let imageUrl = document.get("imageurl") as? String,
//                       let name = data["medicineName"] as? String ,
//                       let dueDate = data["dueDate"] as? String
//                    {
//                           let medicine = Medicine(image: imageUrl, name: name, dueDate: dueDate)
//                           list.append(medicine)
//                          
//                    }
//                    
//                }
//                self.medicineList.onNext(list)
//             
//            }
//        }
//    }
//}
