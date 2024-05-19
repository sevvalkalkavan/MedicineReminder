//
//  CalendarMedicine.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 13.05.2024.
//

import Foundation

class CalendarMedicine{
    
    var medicineID: String
    var medicineName: String
    var medicineDosage: String
    var medicineMeal: String
    var medicineTime: String
    var medDay: [String]
    
    
    init(medicineID: String,medicineName: String, medicineDosage: String, medicineMeal: String, medicineTime: String, medDay: [String]) {
        self.medicineID = medicineID
        self.medicineName = medicineName
        self.medicineDosage = medicineDosage
        self.medicineMeal = medicineMeal
        self.medicineTime = medicineTime
        self.medDay = medDay
    }
    
    
}
