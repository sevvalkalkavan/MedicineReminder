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
import RxSwift
class MedicineViewController: UIViewController {

    @IBOutlet weak var medicineTableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    var firestoreDatabase = Firestore.firestore().collection("Medicine")
   var medicineList = [Medicine]()
   var originalMedicineList = [Medicine]()

    var medicineVievModel = MedicineViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        medicineTableView.dataSource = self
        medicineTableView.delegate = self
        searchTF.delegate = self

       
        _ = medicineVievModel.medicineList.subscribe(onNext: { list in
            self.medicineList = list
            self.originalMedicineList = list
            DispatchQueue.main.async {
                self.medicineTableView.reloadData()
            }
        })

        medicineVievModel.loadData()
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
    
 

}

extension MedicineViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
          searchMedicine(with: newText)
          return true
      }
      
      func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder() // Dismiss the keyboard
          if let searchText = textField.text {
              searchMedicine(with: searchText)
          }
          return true
      }

      func searchMedicine(with searchText: String) {
          guard !searchText.isEmpty else {
              medicineVievModel.loadData()
              return
          }
          
          medicineVievModel.searchMedicine(searchWord: searchText)
      }
}

extension MedicineViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicineList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "medicineCell", for: indexPath) as! MedicineTableViewCell
        cell.nameMedicineLabel.text = medicineList[indexPath.row].name
        cell.dueDateLabel.text = medicineList[indexPath.row].dueDate
        DispatchQueue.main.async {
            cell.medicineImageView.kf.setImage(with: URL(string: self.medicineList[indexPath.row].image))
        }
        //cell.backgroundColor = UIColor(named: "background" )
        cell.cellBackground.layer.cornerRadius = 10.0
        cell.cellBackground.backgroundColor = UIColor(named: "cell")
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
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
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
            let alert = UIAlertController(title: "Delete", message: " Should the \(String(describing: medicine.name)) be deleted?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            let okAction = UIAlertAction(title: "Ok", style: .destructive) { action in
                print(medicine.id)   //bunu id ile yap
                self.medicineVievModel.deleteMedicine(medicineID: medicine.id)
                self.medicineVievModel.loadData()
            }
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
