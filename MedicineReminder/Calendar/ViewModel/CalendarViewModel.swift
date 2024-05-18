//
//  CalendarViewModel.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 16.05.2024.
//

import Foundation
import RxSwift

class CalendarViewModel{
    var dayMedicineList = BehaviorSubject<[CalendarMedicine]>(value: [CalendarMedicine]()) // Add this

    var medicineList = BehaviorSubject<[CalendarMedicine]>(value: [CalendarMedicine]())
    var cRepo = CalendarDaoRepository()
    
    init(){
        medicineList = cRepo.medicineList
        loadData()
    }
    
    func deleteMedicine(medicineID: String){
        cRepo.deleteMedicine(medicineID: medicineID)
    }
    
    func loadData(){
        cRepo.loadData()
    }
    
    func checkAndSendNotification(){
        cRepo.checkAndSendNotification()
    }
    
    func medicineForDate(date: Date) -> [CalendarMedicine] {
            return cRepo.medicineForDate(date: date)
        }
    
}
