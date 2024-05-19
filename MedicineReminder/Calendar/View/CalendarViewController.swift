//
//  CalendarViewController.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 27.04.2024.
//

import UIKit
import UserNotifications

class CalendarViewController: UIViewController {

    
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var medicineTableView: UITableView!
    @IBOutlet weak var weekCollectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
   
    var calendarViewModel = CalendarViewModel()
    
    var selectedDate = Date()
    var totalSquares = [Date]()
    
    var medicineList = [CalendarMedicine]()
    
    
    var permission = UNUserNotificationCenter.current()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        medicineTableView.backgroundColor = UIColor(named: "Color 1")
        medicineTableView.separatorStyle = .none
        medicineTableView.dataSource = self
        medicineTableView.delegate = self
        
        //calendarViewModel.medicineForDate(date: selectedDate)
        medicineTableView.reloadData()
        calendarViewModel.loadData()
        
        
        updateMedicineList(for: selectedDate)
        _ = calendarViewModel.medicineList.subscribe(onNext: { list in
            self.medicineList = list
            DispatchQueue.main.async {
                self.updateMedicineList(for: self.selectedDate)
            }
            
        })
        
       checkPermission()

        weekCollectionView.backgroundColor = UIColor(named: "Color 1")
//        backgroundView.backgroundColor = UIColor(named: "Color 1")

       
        //Navigation
//        self.navigationItem.title = "AppName"
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = UIColor(named: "color")
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
//        navigationController?.navigationBar.barStyle = .black
//        
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
       
        
        weekCollectionView.dataSource = self
        weekCollectionView.delegate = self
        
        let tasarim  = UICollectionViewFlowLayout()
        tasarim.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        tasarim.minimumInteritemSpacing = 2
        
        // 2 x 2 x 2 x 2 x 2 x 2 x 2 x 2 = 16
        let ekranGenislik = UIScreen.main.bounds.width
        let itemGenislik = (ekranGenislik - 16) / 7
        
        tasarim.itemSize = CGSize(width: itemGenislik, height: (itemGenislik * 1.4))
        
        weekCollectionView.collectionViewLayout = tasarim
        setMonthView()
        
//        backgroundView.clipsToBounds = true
//                backgroundView.layer.cornerRadius = 10
//                backgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
//        
        //TabBar
        let apper = UITabBarAppearance()
        apper.backgroundColor = UIColor(named: "color")
        changeColor(itemAppearance: apper.stackedLayoutAppearance)
        changeColor(itemAppearance: apper.inlineLayoutAppearance)
        changeColor(itemAppearance: apper.compactInlineLayoutAppearance)
        tabBarController?.tabBar.standardAppearance = apper
        tabBarController?.tabBar.scrollEdgeAppearance = apper
        
        

    }
    func updateMedicineList(for date: Date) {
            medicineList = calendarViewModel.medicineForDate(date: date)
            medicineTableView.reloadData()
        }
    func checkPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
              case .authorized:
                self.calendarViewModel.checkAndSendNotification()
            case .denied:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        self.calendarViewModel.checkAndSendNotification()
                    }
                }
            default:
                return
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
        calendarViewModel.loadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        medicineTableView.reloadData()
        calendarViewModel.loadData()
    }
    
    func changeColor(itemAppearance: UITabBarItemAppearance){
        //selected
        itemAppearance.selected.iconColor = UIColor.black
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.green]
        
        itemAppearance.normal.iconColor = UIColor.brown
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.purple]
       
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
    

}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "callCell", for: indexPath) as! CalendarCollectionViewCell
        let date = totalSquares[indexPath.item]
        cell.monthOfDayLabel.text = String(CalendarDate().daysOfMonth(date: date))
        cell.weekOfDayLabel.text = CalendarDate().dayOfWeek(date: date) // Set the day of week
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.3
        cell.layer.cornerRadius = 10.0
        if(date == selectedDate)
        {
            cell.backgroundColor = UIColor.systemGreen
        }
        else
        {
            cell.backgroundColor = UIColor.white
        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = totalSquares[indexPath.item]
        weekCollectionView.reloadData()
        medicineTableView.reloadData()
        calendarViewModel.loadData()
        let d = CalendarDate().dayOfWeek(date: selectedDate)
        print(d) //output: Fri Thu
    }
    
}


extension CalendarViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return medicineList.count
        
       return calendarViewModel.medicineForDate(date: selectedDate).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let medicine = calendarViewModel.medicineForDate(date: selectedDate)[indexPath.row]
       // let medicine = medicineList[indexPath.row]
        let cell = medicineTableView.dequeueReusableCell(withIdentifier: "calendarMedicineCell", for: indexPath) as! CalendarMedicineTableViewCell
        cell.medicineNameLabel.text = medicine.medicineName
        cell.mealLabel.text = medicine.medicineMeal
        cell.dosageLabel.text = medicine.medicineDosage
        cell.timeLabel.text = medicine.medicineTime
        cell.backgroundColor = UIColor(named: "Color 1" )
        cell.cellView.layer.cornerRadius = 12.0
        cell.cellView.backgroundColor = UIColor(named: "Color 1")
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { contextualAction, view, bool in
            let medicine = self.medicineList[indexPath.row]
            let alert = UIAlertController(title: "Delete", message: "\(medicine.medicineName) silinsin mi?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            let okAction = UIAlertAction(title: "Ok", style: .destructive) { action in
                print("\(medicine.medicineID)")   //bunu id ile yap
                self.calendarViewModel.deleteMedicine(medicineID: medicine.medicineID)
                self.calendarViewModel.loadData()
            }
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
      
    }
    
    
}
