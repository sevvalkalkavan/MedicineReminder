//
//  LogInviewModel.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 30.05.2024.
//

import Foundation
import UIKit

class LogInviewModel{
    
    var persDaoRepo = PersonalDaoRepository()
    
    func errorAlert(titleInput: String, messageInput: String, viewController: UIViewController) {
        persDaoRepo.errorAlert(titleInput: titleInput, messageInput: messageInput, viewController: viewController)
    }
    
}
