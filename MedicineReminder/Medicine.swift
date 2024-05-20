//
//  Medicine.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 28.04.2024.
//

import Foundation

class Medicine{
    var id: String
    var image: String
    var name: String
    var dueDate: String
    var dosage: String
    var description: String
    var meal: String
    
    
    init(id: String,image: String, name: String, dueDate: String, description: String, meal:String, dosage: String) {
        self.id = id
        self.image = image
        self.name = name
        self.dueDate = dueDate
        self.description = description
        self.meal = meal
        self.dosage = dosage
    }
    
}
