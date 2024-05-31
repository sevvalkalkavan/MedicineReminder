//
//  SignUpViewModel.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 30.05.2024.
//

import Foundation
import UIKit

class SignUpViewModel{
    
    var persDaoRepo = PersonalDaoRepository()
    
    func errorAlert(titleInput: String, messageInput: String, viewController: UIViewController) {
        persDaoRepo.errorAlert(titleInput: titleInput, messageInput: messageInput, viewController: viewController)
    }
    
    func save(name: String, weight: String, height: String, dob: String){
        persDaoRepo.save(name: name, weight: weight, height: height, dob: dob)
    }
}
