//
//  SaveMedicineViewModel.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 30.05.2024.
//

import Foundation

class SaveMedicineViewModel{
    
    var mDaoRepo = MedicineDaoRepository()
    
    func saveMedicine(imageurl: String, description: String , medicineName: String, dosage: String, meal: String ,dueDate: String){
        mDaoRepo.saveMedicine(imageurl: imageurl, description: description, medicineName: medicineName, dosage: dosage, meal: meal, dueDate: dueDate)
    }
    
}
