//
//  User.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 4.05.2024.
//

import Foundation

class User{
    var id: String
    var name: String
    var email: String
    var DoB: String
    
    init(id: String, name: String, email: String, DoB: String) {
        self.id = id
        self.name = name
        self.email = email
        self.DoB = DoB
    }
    
}
