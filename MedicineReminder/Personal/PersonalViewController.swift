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
    
    var personalDaoRepo = PersonalDaoRepository()
    var personList = [Person]()
    override func viewDidLoad() {
        super.viewDidLoad()

        _ = personalDaoRepo.personList.subscribe(onNext: { [weak self] list in
                   guard let self = self, let person = list.first else { return }
                   DispatchQueue.main.async {
                       self.usernameLabel.text = person.username
                       self.ageLabel.text = "\(person.age)"
                       self.weightLabel.text = person.weight
                       self.heightLabel.text = person.height
                   }
               })
//        self.navigationItem.title = "AppName"
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = UIColor(named: "color")
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
//        navigationController?.navigationBar.barStyle = .black
//        
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        personalDaoRepo.loadData()
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
