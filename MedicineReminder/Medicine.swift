//
//  Medicine.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 28.04.2024.
//

import Foundation

class Medicine{
    //var id: Int?
    var image: String?
    var name: String?
    var dueDate: String?
    var dosage: String?
    var description: String?
    var meal: String?
    
    init(image: String? = nil, name: String? = nil, dueDate: String? = nil, description: String? = nil, meal:String? = nil, dosage: String? = nil) {
        self.image = image
        self.name = name
        self.dueDate = dueDate
        self.description = description
        self.meal = meal
        self.dosage = dosage
    }
    
}
