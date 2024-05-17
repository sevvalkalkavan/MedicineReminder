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
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let userEmail = currentUser.email // Assuming you're using email for user identification
        
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Medicine")
            .whereField("username", isEqualTo: userEmail)
            .addSnapshotListener { snapshot, error in
                if error != nil{
                    print(error?.localizedDescription)
                } else {
                    if let snapshot = snapshot, !snapshot.isEmpty {
                        self.originalMedicineList.removeAll(keepingCapacity: false)
                        self.medicineList.removeAll(keepingCapacity: false)
                        
                        for document in snapshot.documents{
                            let documentId = document.documentID
                            print(documentId)
                            if let imageUrl = document.get("imageurl") as? String,
                               let name = document.get("medicineName") as? String,
                               let dueDate = document.get("dueDate") as? String,
                               let description = document.get("description") as? String,
                               let meal = document.get("meal") as? String,
                                let dosage = document.get("dosage") as? String{
                                let medicine = Medicine(image: imageUrl, name: name, dueDate: dueDate, description: description, meal: meal, dosage: dosage)
                                   self.medicineList.append(medicine)
                                   self.originalMedicineList.append(medicine)
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
            let selectedMedicine = medicineList[indexPath.row]
            performSegue(withIdentifier: "toDetailVC", sender: selectedMedicine)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC",
            let detailVC = segue.destination as? DetailMedicineViewController,
            let selectedMedicine = sender as? Medicine {
            detailVC.medicine = selectedMedicine
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { contextualAction, view, bool in
            let medicine = self.medicineList[indexPath.row]
            let alert = UIAlertController(title: "Delete", message: "\(medicine.name) silinsin mi?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            let okAction = UIAlertAction(title: "Ok", style: .destructive) { action in
                print("\(medicine.name)")   //bunu id ile yap
                
            }
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
      
    }
    
}
