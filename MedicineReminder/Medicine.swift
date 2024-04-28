//
//  Medicine.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 28.04.2024.
//

import Foundation

class Medicine{
    var id: Int?
    var image: String?
    var name: String?
    var dueDate: String?
    
    init(id: Int? = nil, image: String? = nil, name: String? = nil, dueDate: String? = nil) {
        self.id = id
        self.image = image
        self.name = name
        self.dueDate = dueDate
    }
    
    
}
