//
//  PersonalViewController.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 27.04.2024.
//

import UIKit
import Firebase

class PersonalViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    var personalViewModel = PersonalViewModel()
    var personList = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Subscribe to personList to update the UI when data is loaded
        _ = personalViewModel.personList.subscribe(onNext: { [weak self] list in
            guard let self = self, let person = list.first else { return }
            DispatchQueue.main.async {
                self.usernameLabel.text = "\(person.username)"
                self.ageLabel.text = "\(person.age)"
                self.weightLabel.text = "\(person.weight)"
                self.heightLabel.text = "\(person.height)"
            }
        })
        
        // Load data when the view loads
        personalViewModel.loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }


    @IBAction func logOutButton(_ sender: Any) {
        do {
                    try Auth.auth().signOut()
                    navigationController?.popToRootViewController(animated: true)
                } catch {
                    print("Error signing out: \(error.localizedDescription)")
                }
        
    }
    
    @IBAction func deleteAccountButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete Account", message: "Do you want to delete the account?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                print("Cancel")
            }
            
            let okAction = UIAlertAction(title: "Ok", style: .destructive) { [weak self] action in
                guard let self = self else { return }
                let personalRepo = PersonalDaoRepository()

                personalRepo.deleteData { error in
                    if let error = error {
                        print("Failed to delete user data: \(error.localizedDescription)")
                    } else {
                        Auth.auth().currentUser?.delete { error in
                            if let error = error {
                                print("Failed to delete user account: \(error.localizedDescription)")
                            } else {
                                do {
                                    try Auth.auth().signOut()
                                    self.navigationController?.popToRootViewController(animated: true)
                                } catch {
                                    print("Error signing out: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
            }
            
            self.present(alertController, animated: true)
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
        
    }
}
