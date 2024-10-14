//
//  ModelCalendar.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 8.10.2024.
//

import Foundation
import CoreData
import RxSwift
import UserNotifications

class ModelCalendar{
    
    var medList = BehaviorSubject<[CalendarModel]>(value: [CalendarModel]())
    let context = appDelegate.persistentContainer.viewContext

    
    
    func save(medicineName: String, dosage: String, meal: String, time: String, medDays: [String]){
        let med = CalendarModel(context: context)
        med.medicineName = medicineName
        med.medicineDosage = dosage
        med.medicineMeal = meal
        med.medicineTime = time
        med.medDay = medDays.joined(separator: ", ")
        med.medID = UUID() 
        print(medicineName)
        appDelegate.saveContext()
        load()
        checkAndSendNotification()
    }
    
    
    func load() {
        do {
            let liste = try context.fetch(CalendarModel.fetchRequest())
            medList.onNext(liste)
        } catch {
            print("Error loading medicines: \(error.localizedDescription)")
        }
    }
    
    func delete(med: CalendarModel){
        context.delete(med)
        appDelegate.saveContext()
        load()
    }
    func checkAndSendNotification() {
        let currentHour = Calendar.current.component(.hour, from: Date())
        let currentMinute = Calendar.current.component(.minute, from: Date())
        let currentDate = Calendar.current.component(.weekday, from: Date())

        _ = medList.subscribe(onNext: { list in
            print("Loaded Medicines: \(list)")
            for medicine in list {
                guard let medDays = medicine.medDay else {
                    print("medDay is nil for medicine: \(medicine)")
                    continue
                }
                
                let medicineWeekdays = medDays.split(separator: ",").map { day -> Int? in
                    switch day.trimmingCharacters(in: .whitespaces) {
                    case "Sun":
                        return 1
                    case "Mon":
                        return 2
                    case "Tue":
                        return 3
                    case "Wed":
                        return 4
                    case "Thu":
                        return 5
                    case "Fri":
                        return 6
                    case "Sat":
                        return 7
                    default:
                        return nil
                    }
                }.compactMap { $0 }

                guard let medicineTime = medicine.medicineTime else {
                    print("medicineTime is nil for medicine: \(medicine.medicineName)")
                    continue
                }

                let timeComponents = medicineTime.split(separator: ":")
                
                guard let medID = medicine.medID else {
                    print("medID is nil for medicine: \(medicine.medicineName)")
                    continue
                }

                if medicineWeekdays.contains(currentDate) {
                    var dateComponents = DateComponents()
                    if let hour = Int(timeComponents[0]), let minute = Int(timeComponents[1]) {
                        dateComponents.hour = hour
                        dateComponents.minute = minute

                        self.dispatchNotification(id: medID.uuidString, title: "Take2Heal", body: "Time to take your medicine: \(medicine.medicineName!)", dateComponents: dateComponents)
                    }
                }
            }
        })
    }


    func dispatchNotification(id: String, title: String, body: String, dateComponents: DateComponents) {
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
        notificationCenter.add(request)
        print("Notification Added: \(id)")
    }

    func medicineForDate(date: Date) -> [CalendarModel] {
           let request: NSFetchRequest<CalendarModel> = CalendarModel.fetchRequest()
           let dayFormatter = DateFormatter()
           dayFormatter.dateFormat = "E" // "Mon", "Tue", etc.
           let dayString = dayFormatter.string(from: date)
           
           request.predicate = NSPredicate(format: "medDay CONTAINS[cd] %@", dayString)

           do {
               let medicines = try context.fetch(request)
               return medicines.sorted { $0.medicineTime! < $1.medicineTime! }
           } catch {
               print("Error fetching medicines for date: \(error.localizedDescription)")
               return []
           }
       }
}
