//
//  CalendarViewController.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 27.04.2024.
//

import UIKit
import UserNotifications
import FirebaseAuth

class CalendarViewController: UIViewController {

  
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var medicineTableView: UITableView!
    @IBOutlet weak var weekCollectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
   
    var calendarViewModel = CalendarViewModel()
    var calendarModelViewModel = CalendarModelViewModel()
    
    var selectedDate = Date()
    var totalSquares = [Date]()
    
    var medicineList = [CalendarMedicine]()
    
    var medList = [CalendarModel]()
    
    
    var permission = UNUserNotificationCenter.current()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "tabBar")
        
        medicineTableView.backgroundColor = UIColor(named: "tabBar")
        medicineTableView.dataSource = self
        medicineTableView.delegate = self
        
        if let _ = Auth.auth().currentUser{
            
            calendarViewModel.loadData()
            medicineTableView.reloadData()
            updateMedicineList(for: selectedDate)
            _ = calendarViewModel.medicineList.subscribe(onNext: { list in
                self.medicineList = list
                DispatchQueue.main.async {
                    self.updateMedicineList(for: self.selectedDate)
                }
                
            })
        }else{
            
//            calendarModelViewModel.load()
//            medicineTableView.reloadData()
//            updateMedicineList(for: selectedDate)
            _ = calendarModelViewModel.medList.subscribe(onNext: { list in
                self.medList = list
               // self.medicineTableView.reloadData()
                DispatchQueue.main.async {
                    self.medicineTableView.reloadData()
                    self.updateMedicineList(for: self.selectedDate)
                }
            })
        }
    
        checkPermission()
        weekCollectionView.backgroundColor = UIColor(named: "tabBar")
        weekCollectionView.dataSource = self
        weekCollectionView.delegate = self
        
        let tasarim  = UICollectionViewFlowLayout()
        tasarim.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        tasarim.minimumInteritemSpacing = 2
        let ekranGenislik = UIScreen.main.bounds.width
        let itemGenislik = (ekranGenislik - 16) / 7
        
        tasarim.itemSize = CGSize(width: itemGenislik, height: (itemGenislik * 1.4))
        
        weekCollectionView.layer.cornerRadius = 5
        weekCollectionView.layer.masksToBounds = true
        weekCollectionView.collectionViewLayout = tasarim
        setMonthView()
       
        let apper = UITabBarAppearance()
        apper.backgroundColor = UIColor(named: "tabBar")
        changeColor(itemAppearance: apper.stackedLayoutAppearance)
        changeColor(itemAppearance: apper.inlineLayoutAppearance)
        changeColor(itemAppearance: apper.compactInlineLayoutAppearance)
        tabBarController?.tabBar.standardAppearance = apper
        tabBarController?.tabBar.scrollEdgeAppearance = apper
        
    }
    
 
    func updateMedicineList(for date: Date) {
        if Auth.auth().currentUser != nil {
            medicineList = calendarViewModel.medicineForDate(date: date)
        } else {
            medList = calendarModelViewModel.medicineForDate(date: date)
        }
        medicineTableView.reloadData()
        
    }

    func checkPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                if let _ = Auth.auth().currentUser {
                    self.calendarViewModel.checkAndSendNotification()
                } else {
                    self.calendarModelViewModel.checkAndSendNotification()
                }
            case .denied:
                return
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        if let _ = Auth.auth().currentUser {
                            self.calendarViewModel.checkAndSendNotification()
                        } else {
                            self.calendarModelViewModel.checkAndSendNotification()
                        }
                    }
                }
            default:
                return
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = Auth.auth().currentUser {
            calendarViewModel.loadData()
        } else {
            calendarModelViewModel.load()
            medicineTableView.reloadData()

        }
    }



    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        medicineTableView.reloadData()
        if Auth.auth().currentUser != nil {
            calendarViewModel.loadData()
        } else {
            calendarModelViewModel.load()
        }
        
    }
    
    func changeColor(itemAppearance: UITabBarItemAppearance){
        
        itemAppearance.selected.iconColor = UIColor(named: "select")
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "select")]
        
        itemAppearance.normal.iconColor = UIColor(named: "notselect")
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "notselect")]
        
    }
    
    
    
    func setMonthView(){
        totalSquares.removeAll()
        
        var current = CalendarDate().sundayForDate(date: selectedDate)
        let nextSunday = CalendarDate().addDays(date: current, days: 7)
        
        while (current < nextSunday){
            totalSquares.append(current)
            current = CalendarDate().addDays(date: current, days: 1)
        }
        
        monthLabel.text = CalendarDate().monthString(date: selectedDate) + ", " + CalendarDate().yearString(date: selectedDate)
        weekCollectionView.reloadData()
        
    }
    
    
    @IBAction func previousWeek(_ sender: Any) {
        selectedDate = CalendarDate().addDays(date: selectedDate, days: -7)
        setMonthView()
    }
    @IBAction func nextWeek(_ sender: Any) {
        selectedDate = CalendarDate().addDays(date: selectedDate, days: 7)
        setMonthView()
    }
    
    
    override open var shouldAutorotate: Bool{
        return false
    }
    
    
    
    @IBAction func addButton(_ sender: Any) {
        if let _ = Auth.auth().currentUser{
            performSegue(withIdentifier: "goSaveVC", sender: self)
            print("current user ")
            
        }else{
            print("Coredata ile devam ")
            performSegue(withIdentifier: "goSaveVC", sender: self)

        }
    }
}


extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "callCell", for: indexPath) as! CalendarCollectionViewCell
        let date = totalSquares[indexPath.item]
        cell.monthOfDayLabel.text = String(CalendarDate().daysOfMonth(date: date))
        cell.weekOfDayLabel.text = CalendarDate().dayOfWeek(date: date)
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.3
        cell.layer.cornerRadius = 10.0
        if(date == selectedDate)
        {
            cell.backgroundColor = UIColor(named: "select")
        }
        else
        {
            cell.backgroundColor = UIColor(named: "background")
        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = totalSquares[indexPath.item]
        updateMedicineList(for: selectedDate)
        weekCollectionView.reloadData()
    }

    
}


extension CalendarViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = Auth.auth().currentUser {
            return medicineList.count
        } else {
            return medList.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let _ = Auth.auth().currentUser {
            let medicine = medicineList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "calendarMedicineCell", for: indexPath) as! CalendarMedicineTableViewCell
            cell.medicineNameLabel.text = medicine.medicineName
            cell.mealLabel.text = medicine.medicineMeal
            cell.dosageLabel.text = medicine.medicineDosage
            cell.timeLabel.text = medicine.medicineTime
            cell.backgroundColor = UIColor(named: "background")
            cell.cellView.layer.cornerRadius = 12.0
            cell.cellView.backgroundColor = UIColor(named: "background")
            return cell
        } else {
            let medicine = medList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "calendarMedicineCell", for: indexPath) as! CalendarMedicineTableViewCell
            cell.medicineNameLabel.text = medicine.medicineName
            cell.mealLabel.text = medicine.medicineMeal
            cell.dosageLabel.text = medicine.medicineDosage
            cell.timeLabel.text = medicine.medicineTime
            cell.backgroundColor = UIColor(named: "background")
            cell.cellView.layer.cornerRadius = 12.0
            cell.cellView.backgroundColor = UIColor(named: "background")
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = Auth.auth().currentUser {
            let medicine = medicineList[indexPath.row]
            print("Firebase'den seçilen ilaç ID'si: \(medicine.medicineID)")
        } else {
            let medicine = medList[indexPath.row]
            print("CoreData'dan seçilen ilaç: \(medicine.medicineName)")
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        
        if let _ = Auth.auth().currentUser{
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { contextualAction, view, bool in
                let medicine = self.medicineList[indexPath.row]
                let alert = UIAlertController(title: "Delete", message: "Should the \(medicine.medicineName) be deleted?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                alert.addAction(cancelAction)
                let okAction = UIAlertAction(title: "Ok", style: .destructive) { action in
                    print("\(medicine.medicineID)")
                    self.calendarViewModel.deleteMedicine(medicineID: medicine.medicineID)
                    self.calendarViewModel.loadData()
                    self.updateMedicineList(for: self.selectedDate)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }

            return UISwipeActionsConfiguration(actions: [deleteAction])
        }else{
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { contextualAction, view, bool in
                let medicine = self.medList[indexPath.row]
                let alert = UIAlertController(title: "Delete", message: "Should the \(medicine.medicineName!) be deleted?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                alert.addAction(cancelAction)
                let okAction = UIAlertAction(title: "Ok", style: .destructive) { action in
                    self.calendarModelViewModel.delete(med: medicine)
                    self.calendarModelViewModel.load()
                    self.updateMedicineList(for: self.selectedDate)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }

            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
    }
}
