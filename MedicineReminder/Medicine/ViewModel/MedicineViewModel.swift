//
//  MedicineViewModel.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 30.05.2024.
//

import Foundation
import RxSwift

class MedicineViewModel{
    var medicineList = BehaviorSubject<[Medicine]>(value: [Medicine]())
    var mDaoRepo = MedicineDaoRepository()
    
    init(){
        medicineList = mDaoRepo.medicineList
        loadData()
    }
    
    func loadData(){
        mDaoRepo.loadData()
    }
    func deleteMedicine(medicineID: String){
        mDaoRepo.deleteMedicine(medicineID: medicineID)
    }
    
    func searchMedicine(searchWord: String){
        mDaoRepo.searchMedicine(searchWord: searchWord)
    }
}
