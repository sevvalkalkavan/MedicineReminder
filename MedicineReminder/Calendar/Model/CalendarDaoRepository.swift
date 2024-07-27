import Foundation
import RxSwift
import FirebaseFirestore
import UserNotifications
import FirebaseAuth

class CalendarDaoRepository {
    var medicineList = BehaviorSubject<[CalendarMedicine]>(value: [CalendarMedicine]())
    var permission = UNUserNotificationCenter.current()
    var collectionMedicineCalendar = Firestore.firestore().collection("medicineCalendar")

    func saveMedicine(medicineID: String, medicineName: String, dosage: String, meal: String, time: String, medDays: [String]) {
        let med: [String: Any] = [
            "med_id": medicineID,
            "med_name": medicineName,
            "dosage": dosage,
            "meal": meal,
            "time": time,
            "medDay": medDays,
            "username": Auth.auth().currentUser!.email!
        ]
        collectionMedicineCalendar.document(medicineID).setData(med)
    }

    func deleteMedicine(medicineID: String) {
        collectionMedicineCalendar.whereField("med_id", isEqualTo: medicineID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error deleting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
                print("silinen id: \(medicineID)")
                self.loadData()
            }
        }
    }

    func loadData() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let userEmail = currentUser.email
        collectionMedicineCalendar.whereField("username", isEqualTo: userEmail!).addSnapshotListener { snapshot, error in
            var list = [CalendarMedicine]()
            if let documents = snapshot?.documents {
                for document in documents {
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
        let currentDate = Calendar.current.component(.weekday, from: Date())
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
                        return 7
                    default:
                        return nil
                    }
                }.compactMap { $0 }

                let timeComponents = medicine.medicineTime.split(separator: ":")
                if medicineWeekdays.contains(currentDate) {
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
        dayFormatter.dateFormat = "E" // "Mon", "Tue", etc.
        let dayString = dayFormatter.string(from: date)

        if let medicines = try? medicineList.value() {
            var seenMedicines = Set<String>()
            for med in medicines {
                if med.medDay.contains(dayString) && !seenMedicines.contains(med.medicineName) {
                    dayMedicine.append(med)
                    seenMedicines.insert(med.medicineName)
                }
            }
        }

        return dayMedicine.sorted { $0.medicineTime < $1.medicineTime }
    }
}
