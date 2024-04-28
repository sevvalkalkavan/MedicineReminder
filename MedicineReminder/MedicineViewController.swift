//
//  MedicineViewController.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 27.04.2024.
//

import UIKit

class MedicineViewController: UIViewController {

    @IBOutlet weak var medicineTableView: UITableView!
    
    var medicineList = [Medicine]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        medicineTableView.dataSource = self
        medicineTableView.delegate = self
        
        let m1 = Medicine(id: 1, image: "pill", name: "Medicine Name" , dueDate: "22.05.2024")
        medicineList.append(m1)
        let m2 = Medicine(id: 1, image: "pill", name: "Medicine Name" , dueDate: "22.05.2024")
        medicineList.append(m2)
        let m3 = Medicine(id: 1, image: "pill", name: "Medicine Name" , dueDate: "22.05.2024")
        medicineList.append(m3)
        let m4 = Medicine(id: 1, image: "pill", name: "Medicine Name" , dueDate: "22.05.2024")
        medicineList.append(m4)
        let m5 = Medicine(id: 1, image: "pill", name: "Medicine Name" , dueDate: "22.05.2024")
        medicineList.append(m5)
        let m6 = Medicine(id: 1, image: "pill", name: "Medicine Name" , dueDate: "22.05.2024")
        medicineList.append(m6)
        let m7 = Medicine(id: 1, image: "pill", name: "Medicine Name" , dueDate: "22.05.2024")
        medicineList.append(m7)

//        self.navigationItem.title = "AppName"
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = UIColor(named: "color")
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
//        navigationController?.navigationBar.barStyle = .black
//        
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }

}

extension MedicineViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicineList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let medicine = medicineList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "medicineCell") as! MedicineTableViewCell
        cell.medicineImageView.image = UIImage(named: medicine.image!)
        cell.nameMedicineLabel.text = medicine.name
        cell.dueDateLabel.text = medicine.dueDate
        cell.backgroundColor = UIColor(named: "Color 1" )
        cell.cellBackground.layer.cornerRadius = 10.0
        cell.cellBackground.backgroundColor = UIColor(named: "Color 2")
        return cell
    }
    
}
