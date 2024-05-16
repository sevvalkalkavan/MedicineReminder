//
//  CalendarDaoRepository.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 16.05.2024.
//

import Foundation
import RxSwift
import FirebaseFirestore

class CalendarDaoRepository{
    
    var medicineList = BehaviorSubject<[CalendarMedicine]>(value: [CalendarMedicine]())
    var collectionMedicineCalendar = Firestore.firestore().collection("medicineCalendar")
    
    
    
    func saveMedicine(medicineName: String, dosage: String, meal: String, time: String){
        let med:[String:Any] = ["med_id":"" , "med_name":medicineName, "dosage":dosage, "meal":meal, "time":time]
        collectionMedicineCalendar.document().setData(med)
    }
    
    
    
    func deleteMedicine(medicineID: String){
        collectionMedicineCalendar.document(medicineID).delete()
    }
    
    
    
    func loadData(){
        collectionMedicineCalendar.addSnapshotListener{ snapshot, error in
            var list = [CalendarMedicine]()
            
            if let documents = snapshot?.documents{
                for document in documents{
                    let data = document.data()
                    let medicineID = document.documentID
                    let medicineName = data["med_name"] as? String ?? ""
                    let medicineDosage = data["dosage"] as? String ?? ""
                    let medicineMeal = data["meal"] as? String ?? ""
                    let medicineTime = data["time"] as? String ?? ""
                    
                    let med = CalendarMedicine(medicineID: medicineID, medicineName: medicineName, medicineDosage: medicineDosage, medicineMeal: medicineMeal, medicineTime: medicineTime)
                    list.append(med)
                }
            }
            
            self.medicineList.onNext(list)
        }
        
    }
    
    
}
