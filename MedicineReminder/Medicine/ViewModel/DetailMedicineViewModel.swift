//
//  DetailMedicineViewModel.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 30.05.2024.
//

import Foundation
import RxSwift

class DetailMedicineViewModel{
    
    var medicineList = BehaviorSubject<[Medicine]>(value: [Medicine]())

    var mDaoRepo = MedicineDaoRepository()
    
}
