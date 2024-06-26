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
                self.usernameLabel.text = "Username: \(person.username)"
                self.ageLabel.text = "Age: \(person.age)"
                self.weightLabel.text = "Weight: \(person.weight)"
                self.heightLabel.text = "Height: \(person.height)"
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
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toVC", sender: nil)
        }catch{
            
        }
        
    }
}
