//
//  CalendarMedicine.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 13.05.2024.
//

import Foundation

class CalendarMedicine{
    var medicineName: String
    var medicineDosage: String
    var medicineMeal: String
    var medicineTime: String
    
    init(medicineName: String, medicineDosage: String, medicineMeal: String, medicineTime: String) {
        self.medicineName = medicineName
        self.medicineDosage = medicineDosage
        self.medicineMeal = medicineMeal
        self.medicineTime = medicineTime
    }
}
