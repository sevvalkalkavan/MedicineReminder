//
//  MedicineViewController.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 27.04.2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import Kingfisher
class MedicineViewController: UIViewController {

    @IBOutlet weak var medicineTableView: UITableView!
    
//    var medicineList = [Medicine]()
    
    var nameList = [String]()
    var dateList = [String]()
    var imageList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        medicineTableView.dataSource = self
        medicineTableView.delegate = self
        
//        let m1 = Medicine(id: 1, image: "pill", name: "Medicine Name" , dueDate: "22.05.2024")
//        medicineList.append(m1)
//        let m2 = Medicine(id: 1, image: "pill", name: "Medicine Name" , dueDate: "22.05.2024")
//        medicineList.append(m2)
//        let m3 = Medicine(id: 1, image: "pill", name: "Medicine Name" , dueDate: "22.05.2024")
//        medicineList.append(m3)
//        let m4 = Medicine(id: 1, image: "pill", name: "Medicine Name" , dueDate: "22.05.2024")
//        medicineList.append(m4)
//        let m5 = Medicine(id: 1, image: "pill", name: "Medicine Name" , dueDate: "22.05.2024")
//        medicineList.append(m5)
//        let m6 = Medicine(id: 1, image: "pill", name: "Medicine Name" , dueDate: "22.05.2024")
//        medicineList.append(m6)
//        let m7 = Medicine(id: 1, image: "pill", name: "Medicine Name" , dueDate: "22.05.2024")
//        medicineList.append(m7)

//        self.navigationItem.title = "AppName"
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = UIColor(named: "color")
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
//        navigationController?.navigationBar.barStyle = .black
//        
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        fetchFirebase()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    
    func fetchFirebase(){
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Medicine").addSnapshotListener { snapshot, error in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                if snapshot?.isEmpty != true && snapshot != nil{
                    
                    //bir değerin iki kere yüklenmesi gösterilmesini engeller
                    self.dateList.removeAll(keepingCapacity: false)
                    self.imageList.removeAll(keepingCapacity: false)
                    self.nameList.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        let documentId = document.documentID
                        print(documentId)
                        if let imageUrl = document.get("imageurl") as? String{
                            self.imageList.append(imageUrl)
                        }
                        if let name = document.get("medicineName") as? String{
                            self.nameList.append(name)
                        }
                        if let dueDate = document.get("dueDate") as? String{
                            self.dateList.append(dueDate)
                        }
                        
                    }
                    self.medicineTableView.reloadData()
                }
            }
        }
        
    }
    

}

extension MedicineViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return medicineList.count
        return nameList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let medicine = medicineList[indexPath.row]
          let cell = tableView.dequeueReusableCell(withIdentifier: "medicineCell", for: indexPath) as! MedicineTableViewCell
//        cell.medicineImageView.image = UIImage(named: medicine.image!)
        cell.nameMedicineLabel.text = nameList[indexPath.row]
        cell.dueDateLabel.text = dateList[indexPath.row]
        DispatchQueue.main.async {
            cell.medicineImageView.kf.setImage(with: URL(string: self.imageList[indexPath.row]))
        }
       cell.backgroundColor = UIColor(named: "Color 1" )
       cell.cellBackground.layer.cornerRadius = 10.0
     cell.cellBackground.backgroundColor = UIColor(named: "Color 2")
          return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailVC", sender: self) 
    }
    
}
