//
//  PersonalViewModel.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 30.05.2024.
//

import Foundation
import RxSwift

class PersonalViewModel{
    
    var persDaoRepo = PersonalDaoRepository()
    var personList: Observable<[Person]> {
        return persDaoRepo.personList.asObservable()
    }
    
    func loadData(){
        persDaoRepo.loadData()
    }
    
}
