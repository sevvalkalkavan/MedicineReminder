//
//  CalendarViewController.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 27.04.2024.
//

import UIKit

class CalendarViewController: UIViewController {

    
    @IBOutlet weak var medicineTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    var selectedDate = Date()
    var totalSquares = [Date]()
    
    
    var medicineList = [CalendarMedicine]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        medicineTableView.backgroundColor = UIColor(named: "Color 1")
        medicineTableView.separatorStyle = .none
        medicineTableView.dataSource = self
        medicineTableView.delegate = self
        
        let m1 = CalendarMedicine(medicineName: "Parol", medicineDosage: "1 Capsule", medicineMeal: "After Meal", medicineTime: "12:00 AM")
        let m2 = CalendarMedicine(medicineName: "Parol", medicineDosage: "1 Capsule", medicineMeal: "After Meal", medicineTime: "12:00 AM")
        medicineList.append(m1)
        medicineList.append(m2)

        collectionView.backgroundColor = UIColor(named: "Color 1")
        backgroundView.backgroundColor = UIColor(named: "Color 1")

       
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
        
        setCellsView()
        setMonthView()
        
        backgroundView.clipsToBounds = true
                backgroundView.layer.cornerRadius = 10
                backgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
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
    
    
    func setCellsView()
    {
    let layout = UICollectionViewFlowLayout()
     layout.minimumInteritemSpacing = 5 // Hücreler arası yatay boşluk
     layout.minimumLineSpacing = 10 // Satırlar arası dikey boşluk
     let itemWidth = (collectionView.frame.width - 6 * layout.minimumInteritemSpacing) / 7 // Assuming 7 items per row
     let itemHeight = (collectionView.frame.height - 5 * layout.minimumLineSpacing) / 6 // Assuming 6 rows
     layout.itemSize = CGSize(width: itemWidth, height: itemHeight + 100)
        collectionView.collectionViewLayout = layout
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
        collectionView.reloadData()
        
    }
    
    
    @IBAction func nextWeek(_ sender: Any) {
        selectedDate = CalendarDate().addDays(date: selectedDate, days: 7)
        setMonthView()
    }
    
    @IBAction func previousWeek(_ sender: Any) {
        selectedDate = CalendarDate().addDays(date: selectedDate, days: -7)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "callCell", for: indexPath) as! CalendarCell
        let date = totalSquares[indexPath.item]
        cell.dayOfMonth.text = String(CalendarDate().daysOfMonth(date: date))
        cell.dayOfWeek.text = CalendarDate().dayOfWeek(date: date) // Set the day of week
        
        if (date == selectedDate) {
           //cell.backgroundColor = UIColor.blue
        }
        print(selectedDate)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = totalSquares[indexPath.item]
        collectionView.reloadData()
    }
    
}


extension CalendarViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicineList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let medicine = medicineList[indexPath.row]
        let cell = medicineTableView.dequeueReusableCell(withIdentifier: "calendarMedicineCell", for: indexPath) as! CalendarMedicineTableViewCell
        cell.medicineNameLabel.text = medicine.medicineName
        cell.medicineMealLabel.text = medicine.medicineMeal
        cell.medicineDosageLabel.text = medicine.medicineDosage
        cell.medicineTimeLabel.text = medicine.medicineTime
        cell.backgroundColor = UIColor(named: "Color 1" )
        cell.cellBackground.layer.cornerRadius = 10.0
        cell.cellBackground.backgroundColor = UIColor(named: "Color 2")
        return cell
    }
    
    
}
