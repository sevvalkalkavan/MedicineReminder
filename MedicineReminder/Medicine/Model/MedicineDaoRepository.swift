//  MedicineDaoRepository.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 30.05.2024.
//

import Foundation
import RxSwift
import FirebaseFirestore
import FirebaseAuth

class MedicineDaoRepository {
    
    var collectionMedicine = Firestore.firestore().collection("Medicine")
    var medicineList = BehaviorSubject<[Medicine]>(value: [Medicine]())
    var originalMedicineList = [Medicine]()
    
    func saveMedicine(imageurl: String, description: String, medicineName: String, dosage: String, meal: String, dueDate: String) {
        let medicine: [String: Any] = [
            "med_id": "",
            "imageurl": imageurl,
            "description": description,
            "medicineName": medicineName,
            "username": Auth.auth().currentUser!.email!,
            "dosage": dosage,
            "meal": meal,
            "dueDate": dueDate
        ]
        collectionMedicine.document().setData(medicine)
    }
    
    func loadData() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let userEmail = currentUser.email
        collectionMedicine.whereField("username", isEqualTo: userEmail!).addSnapshotListener { snapshot, error in
            var list = [Medicine]()
            if let documents = snapshot?.documents {
                for document in documents {
                    let data = document.data()
                    let medicineID = document.documentID
                    let medicineName = data["medicineName"] as? String ?? ""
                    let medicineDosage = data["dosage"] as? String ?? ""
                    let medicineMeal = data["meal"] as? String ?? ""
                    let medicineDate = data["dueDate"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let imageurl = data["imageurl"] as? String ?? ""
                    
                    let med = Medicine(id: medicineID, image: imageurl, name: medicineName, dueDate: medicineDate, description: description, meal: medicineMeal, dosage: medicineDosage)
                    list.append(med)
                }
            }
            list = self.sortDate(list: list)
            self.medicineList.onNext(list)
        }
    }
    
    func deleteMedicine(medicineID: String) {
        collectionMedicine.document(medicineID).delete()
    }
    
    func searchMedicine(searchWord: String) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let userEmail = currentUser.email
        collectionMedicine.whereField("username", isEqualTo: userEmail!).addSnapshotListener { snapshot, error in
            var list = [Medicine]()
            if let documents = snapshot?.documents {
                for document in documents {
                    let data = document.data()
                    let medicineID = document.documentID
                    let medicineName = data["medicineName"] as? String ?? ""
                    let medicineDosage = data["dosage"] as? String ?? ""
                    let medicineMeal = data["meal"] as? String ?? ""
                    let medicineDate = data["dueDate"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let imageurl = data["imageurl"] as? String ?? ""
                    
                    if medicineName.lowercased().contains(searchWord.lowercased()) {
                        let med = Medicine(id: medicineID, image: imageurl, name: medicineName, dueDate: medicineDate, description: description, meal: medicineMeal, dosage: medicineDosage)
                        list.append(med)
                    }
                }
            }
            list = self.sortDate(list: list)
            self.medicineList.onNext(list)
        }
    }
    
    func sortDate(list: [Medicine]) -> [Medicine] {
        return list.sorted { (medicine1, medicine2) -> Bool in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy" // Assuming date is in this format
            if let date1 = dateFormatter.date(from: medicine1.dueDate),
               let date2 = dateFormatter.date(from: medicine2.dueDate) {
                return date1 < date2
            }
            return false
        }
    }
}
