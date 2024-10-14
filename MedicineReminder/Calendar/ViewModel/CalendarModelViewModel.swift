//
//  CalendarModelViewModel.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 8.10.2024.
//

import Foundation
import RxSwift

class CalendarModelViewModel{
    
    var modelCalendar = ModelCalendar()
    var medList = BehaviorSubject<[CalendarModel]>(value: [CalendarModel]())

    init(){
        medList = modelCalendar.medList
        load()
    }
    func delete(med: CalendarModel){
        modelCalendar.delete(med: med)
    }
    func checkAndSendNotification(){
        modelCalendar.checkAndSendNotification()
    }
    
    func medicineForDate(date: Date) -> [CalendarModel] {
        return modelCalendar.medicineForDate(date: date)
    }
    func load(){
        modelCalendar.load()
    }
}
