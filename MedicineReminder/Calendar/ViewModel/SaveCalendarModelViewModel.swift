//
//  SaveCalendarModelViewModel.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 8.10.2024.
//

import Foundation

class SaveCalendarModelViewModel{
    var modelCalendar = ModelCalendar()
    
    
    
    func save(medicineName: String, dosage: String, meal: String, time: String, medDays: [String]){
        modelCalendar.save(medicineName: medicineName, dosage: dosage, meal: meal, time: time, medDays: medDays)
    }
    
    func load(){
        modelCalendar.load()
    }
}
