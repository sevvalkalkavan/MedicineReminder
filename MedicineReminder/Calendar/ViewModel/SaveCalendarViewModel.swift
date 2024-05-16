//
//  SaveCalendarViewModel.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 16.05.2024.
//

import Foundation


class SaveCalendarViewModel{
    
    var cRepo = CalendarDaoRepository()
    
    func saveMedicine(medicineName: String, dosage: String, meal: String, time: String){
        cRepo.saveMedicine(medicineName: medicineName, dosage: dosage, meal: meal, time: time)
    }
    
}
