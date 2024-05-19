//
//  Person.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 19.05.2024.
//

import Foundation

class Person{
    var id: String
    var username: String
    var weight: String
    var height: String
    var DoB: String
    var age: Int
    
    init(id: String, username: String, weight: String, height: String, DoB: String, age: Int) {
        self.id = id
        self.username = username
        self.weight = weight
        self.height = height
        self.DoB = DoB
        self.age = age
    }
    
}
