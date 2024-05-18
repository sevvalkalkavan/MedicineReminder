//
//  CalendarDaoRepository.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 16.05.2024.
//

import Foundation
import RxSwift
import FirebaseFirestore
import UserNotifications
import FirebaseAuth

class CalendarDaoRepository{
    
    var medicineList = BehaviorSubject<[CalendarMedicine]>(value: [CalendarMedicine]())
    var collectionMedicineCalendar = Firestore.firestore().collection("medicineCalendar")
    var dayMedicineList = BehaviorSubject<[CalendarMedicine]>(value: [CalendarMedicine]())
    var permission = UNUserNotificationCenter.current()
    
    
    func saveMedicine(medicineName: String, dosage: String, meal: String, time: String, medDay: [String]){
        let med:[String:Any] = ["med_id":"" , "med_name":medicineName, "dosage":dosage, "meal":meal, "time":time, "medDay": medDay,"username": Auth.auth().currentUser!.email]
        collectionMedicineCalendar.document().setData(med)
    }
    
    
    
    func deleteMedicine(medicineID: String){
        collectionMedicineCalendar.document(medicineID).delete()
    }
    
    
    
    func loadData(){
        guard let currentUser = Auth.auth().currentUser else {
            
            return
        }
        let userEmail = currentUser.email
        collectionMedicineCalendar.whereField("username", isEqualTo: userEmail).addSnapshotListener{ snapshot, error in
            var list = [CalendarMedicine]()
            if let documents = snapshot?.documents{
                for document in documents{
                    let data = document.data()
                    let medicineID = document.documentID
                    let medicineName = data["med_name"] as? String ?? ""
                    let medicineDosage = data["dosage"] as? String ?? ""
                    let medicineMeal = data["meal"] as? String ?? ""
                    let medicineTime = data["time"] as? String ?? ""
                    let medicineDays = data["medDay"] as? [String] ?? []
                    
                    let med = CalendarMedicine(medicineID: medicineID, medicineName: medicineName, medicineDosage: medicineDosage, medicineMeal: medicineMeal, medicineTime: medicineTime, medDay: medicineDays)
                    list.append(med)
                }
            }
            
            self.medicineList.onNext(list)
        }
        
    }
    func checkAndSendNotification() {
         let currentHour = Calendar.current.component(.hour, from: Date())
         let currentMinute = Calendar.current.component(.minute, from: Date())
         print("Current Time: \(currentHour):\(currentMinute)") // Debug
         

        _ = medicineList.subscribe(onNext: { list in
            print("Loaded Medicines: \(list)") // Debug
            for medicine in list {
                let timeComponents = medicine.medicineTime.split(separator: ":")
                if let hour = Int(timeComponents[0]), let minute = Int(timeComponents[1]) {
                    var dateComponents = DateComponents()
                    dateComponents.hour = hour
                    dateComponents.minute = minute
                    
                    // Call dispatchNotification with dateComponents
                    self.dispatchNotification(id: medicine.medicineID, title: "Medicine Reminder", body: "Time to take your medicine: \(medicine.medicineName)", dateComponents: dateComponents)
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
    
    func medicineForDate(date: Date) -> [CalendarMedicine]{
        var dayMedicine = [CalendarMedicine]()
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "E" // Abbreviated weekday name, e.g., "Mon"
        let dayString = dayFormatter.string(from: date)
        
        _ = medicineList.subscribe(onNext: { list in
            for med in list {
                if med.medDay.contains(dayString) {
                    dayMedicine.append(med)
                }
            }
            self.dayMedicineList.onNext(dayMedicine)
        })
        print(dayMedicine)
        return dayMedicine
    }
}


                                   
