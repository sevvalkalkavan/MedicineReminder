//
//  Created by Şevval Kalkavan on 13.05.2024.
//


import Foundation
import RxSwift
import FirebaseFirestore
import UserNotifications
import FirebaseAuth
class CalendarDaoRepository{
    
    var medicineList = BehaviorSubject<[CalendarMedicine]>(value: [CalendarMedicine]())
    var collectionMedicineCalendar = Firestore.firestore().collection("medicineCalendar")
    var permission = UNUserNotificationCenter.current()
    
    
    func saveMedicine(medicineName: String, dosage: String, meal: String, time: String, medDay: [String]){
        let med:[String:Any] = ["med_id":"" , "med_name":medicineName, "dosage":dosage, "meal":meal, "time":time, "medDay": medDay,"username": Auth.auth().currentUser!.email!]
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
        collectionMedicineCalendar.whereField("username", isEqualTo: userEmail!).addSnapshotListener{ snapshot, error in
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

                    // list.sorted(){ $0.medicineName > $1.medicineName}
                     list.append(med)
                 }
             }


             self.medicineList.onNext(list)
         }
        
    }

    
    func checkAndSendNotification() {
        let currentHour = Calendar.current.component(.hour, from: Date())
        let currentMinute = Calendar.current.component(.minute, from: Date())
        let currentDate = Calendar.current.component(.weekday, from: Date())
        print("Current Time: \(currentHour):\(currentMinute)")
        print(currentDate)
        _ = medicineList.subscribe(onNext: { list in
            print("Loaded Medicines: \(list)")
            for medicine in list {
                let medicineWeekdays = medicine.medDay.map { day -> Int? in
                    
                    switch day {
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
                        return  7
                    default:
                        return nil
                    }
                }.compactMap { $0 }
                
                let timeComponents = medicine.medicineTime.split(separator: ":")
                if medicineWeekdays.contains(currentDate)  {
                    var dateComponents = DateComponents()
                    if let hour = Int(timeComponents[0]), let minute = Int(timeComponents[1]) {
                        var dateComponents = DateComponents()
                        dateComponents.hour = hour
                        dateComponents.minute = minute
                        
                        
                        self.dispatchNotification(id: medicine.medicineID, title: "Take2Heal", body: "Time to take your medicine: \(medicine.medicineName)", dateComponents: dateComponents)
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
    
  
    func medicineForDate(date: Date) -> [CalendarMedicine] {
            var dayMedicine = [CalendarMedicine]()
            let dayFormatter = DateFormatter()
           dayFormatter.dateFormat = "E" // "Mon"
           let dayString = dayFormatter.string(from: date)
           
           _ = medicineList.subscribe(onNext: { list in
               for med in list {
                   if med.medDay.contains(dayString) {
                       dayMedicine.append(med)
                       
                   }
               }
           })
           return dayMedicine.sorted(){$0.medicineTime < $1.medicineTime}
       }
    
    
    
    //    func checkForPermission() {
    //        let notificationCenter = UNUserNotificationCenter.current()
    //        notificationCenter.getNotificationSettings { settings in
    //            switch settings.authorizationStatus {
    //            case .authorized:
    //                self.dispatchNotification()
    //            case .denied:
    //                return
    //            case .notDetermined:
    //                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
    //                    if didAllow {
    //                        self.dispatchNotification()
    //                    }
    //                }
    //                default:
    //                    return
    //                }
    //            }
    //        }
    //    func dispatchNotification () {
    //        let id = "id"
    //        let title = "Time to work out!"
    //        let body = "Don't be a lazy little butt!"
    //        let hour = 16
    //        let minute = 39
    //        let isDaily = true
    //        let notificationCenter = UNUserNotificationCenter.current()
    //        let content = UNMutableNotificationContent()
    //        content.title = title
    //        content.body = body
    //        content.sound = .default
    //        let calendar = Calendar.current
    //        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
    //        dateComponents.hour = hour
    //        dateComponents.minute = minute
    //        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
    //        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
    //        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    //        notificationCenter.add(request)
    //    }
 }
