//
//  CalendarDate.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 12.05.2024.
//

import Foundation

class CalendarDate{
    
    var calendar = Calendar.current
    
    func monthString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"  //January
        return dateFormatter.string(from: date)
    }
    func yearString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"   //2024
        return dateFormatter.string(from: date)
    }
    func daysOfMonth(date: Date) -> Int{
        let components = calendar.dateComponents([.day], from: date) //input: 15 January 2021 output: 15
        return components.day!
    }
    func addDays(date: Date, days: Int) -> Date {
        return calendar.date(byAdding: .day, value: days, to: date)!  //her hafta temsil etmek için 7 ekleyip çıakrıcaz
    }
    func sundayForDate(date: Date) -> Date{
        var current = date
        let oneWeekAgo = addDays(date: current, days: -7) //bir hafta geri gidilir
        while(current > oneWeekAgo){    //bu pazar geçen hafta pazardan büyük oldupu sürece
            
            let currentWeekDay = calendar.dateComponents([.weekday], from: current).weekday
            if (currentWeekDay == 1){  //eğer pazara denk geliyorsa
                return current
            }
            
            current = addDays(date: current, days: -1)
        }
        return current
    }
    func dayOfWeek(date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E" // "E" represents  "Mon", "Tue"
           // dateFormatter.locale = Locale(identifier: "tr")
            return dateFormatter.string(from: date)
        }
    
}
