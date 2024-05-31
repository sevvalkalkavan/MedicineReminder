//
//  DetailMedicineViewController.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 28.04.2024.
//

import UIKit
import Firebase
import FirebaseFirestore

class DetailMedicineViewController: UIViewController {

    @IBOutlet weak var medicineImageView: UIImageView!
    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var detailViewModel = DetailMedicineViewModel()
    
    var medicine: Medicine?
   var medicineList = [Medicine]()
   var originalMedicineList = [Medicine]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let medicine = medicine {
            medicineImageView.kf.setImage(with: URL(string: medicine.image))
                    medicineNameLabel.text = medicine.name
                    dosageLabel.text = medicine.dosage
                    descriptionLabel.text = medicine.description
                    mealLabel.text = medicine.meal
                    dueDateLabel.text = medicine.dueDate
                }
    }
    
  
    



}
