//
//  CalendarViewController.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 27.04.2024.
//

import UIKit

class CalendarViewController: UIViewController {

    
    @IBOutlet weak var weekCollectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    
    var selectedDate = Date()
    var totalSquares = [Date]()
    
    
    var medicineList = [CalendarMedicine]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        weekCollectionView.backgroundColor = UIColor(named: "Color 1")
//        weekCollectionView.separatorStyle = .none
        weekCollectionView.dataSource = self
        weekCollectionView.delegate = self
        
//        let m1 = CalendarMedicine(medicineName: "Parol", medicineDosage: "1 Capsule", medicineMeal: "After Meal", medicineTime: "12:00 AM")
//        let m2 = CalendarMedicine(medicineName: "Parol", medicineDosage: "1 Capsule", medicineMeal: "After Meal", medicineTime: "12:00 AM")
//        medicineList.append(m1)
//        medicineList.append(m2)

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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
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
        
        monthLabel.text = CalendarDate().monthString(date: selectedDate) + " " + CalendarDate().yearString(date: selectedDate)
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
        if (date == selectedDate) {
           //cell.backgroundColor = UIColor.blue
        }
        print(selectedDate)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = totalSquares[indexPath.item]
        weekCollectionView.reloadData()
    }
    
}


//extension CalendarViewController: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return medicineList.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let medicine = medicineList[indexPath.row]
//        let cell = medicineTableView.dequeueReusableCell(withIdentifier: "calendarMedicineCell", for: indexPath) as! CalendarMedicineTableViewCell
//        cell.medicineNameLabel.text = medicine.medicineName
//        cell.medicineMealLabel.text = medicine.medicineMeal
//        cell.medicineDosageLabel.text = medicine.medicineDosage
//        cell.medicineTimeLabel.text = medicine.medicineTime
//        cell.backgroundColor = UIColor(named: "Color 1" )
//        cell.cellBackground.layer.cornerRadius = 10.0
//        cell.cellBackground.backgroundColor = UIColor(named: "Color 2")
//        return cell
//    }
//    
//    
//}
