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
    @IBOutlet weak var searchTF: UITextField!
    
   var medicineList = [Medicine]()
   var originalMedicineList = [Medicine]()
//    var nameList = [String]()
//    var dateList = [String]()
//    var imageList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        medicineTableView.dataSource = self
        medicineTableView.delegate = self
        searchTF.delegate = self



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
    
    
    @IBAction func searchButton(_ sender: Any) {
        searchTF.endEditing(true)
        print(searchTF.text!)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
        medicineTableView.reloadData()
    }
    
    
    func fetchFirebase(){
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Medicine").addSnapshotListener { snapshot, error in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                if let snapshot = snapshot, !snapshot.isEmpty {
                                    self.originalMedicineList.removeAll(keepingCapacity: false)
                                    self.medicineList.removeAll(keepingCapacity: false)
                    
                    for document in snapshot.documents{
                        let documentId = document.documentID
                        print(documentId)
                        if let imageUrl = document.get("imageurl") as? String{
                           // self.imageList.append(imageUrl)
                            if let name = document.get("medicineName") as? String{
                                //self.nameList.append(name)
                                if let dueDate = document.get("dueDate") as? String{
                                   // self.dateList.append(dueDate)
                                    let medicine = Medicine(image: imageUrl, name: name, dueDate: dueDate)
                                    self.medicineList.append(medicine)
                                    self.originalMedicineList.append(medicine)
                                }
                            }
                        }
                        
                        
                        
                    }
                    self.medicineTableView.reloadData()
                }
            }
        }
        
    }
    

}


extension MedicineViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            searchMedicine(with: newText)
            return true
        }
    
    func searchMedicine(with searchText: String) {
        guard !searchText.isEmpty else {
            // If the search text is empty, reload the original list
            medicineList = originalMedicineList
            medicineTableView.reloadData()
            return
        }
        
        let filteredMedicines = originalMedicineList.filter { $0.name!.lowercased().contains(searchText.lowercased()) }
        medicineList = filteredMedicines
        medicineTableView.reloadData()
    }
        
 

    
}


extension MedicineViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return medicineList.count
        return medicineList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let medicine = medicineList[indexPath.row]
          let cell = tableView.dequeueReusableCell(withIdentifier: "medicineCell", for: indexPath) as! MedicineTableViewCell
//        cell.medicineImageView.image = UIImage(named: medicine.image!)
        cell.nameMedicineLabel.text = medicineList[indexPath.row].name
        cell.dueDateLabel.text = medicineList[indexPath.row].dueDate
        DispatchQueue.main.async {
            cell.medicineImageView.kf.setImage(with: URL(string: self.medicineList[indexPath.row].image!))
        }
       cell.backgroundColor = UIColor(named: "Color 1" )
       cell.cellBackground.layer.cornerRadius = 10.0
       cell.cellBackground.backgroundColor = UIColor(named: "Color 2")
          return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailVC", sender: self) 
        medicineTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if yOffset > 0 {
            // Scrolling downwards, hide the navigation bar
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            // Scrolling upwards, show the navigation bar
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
}
