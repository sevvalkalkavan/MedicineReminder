//
//  SaveCalendarMedicineViewController.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 14.05.2024.
//

import UIKit

class SaveCalendarMedicineViewController: UIViewController {

    var saveModel = SaveCalendarViewModel()
    
    @IBOutlet weak var medicineNameTF: UITextField!
    @IBOutlet weak var dosageTF: UITextField!
    @IBOutlet weak var mealTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    var timePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timePicker = UIDatePicker()
        timePicker?.datePickerMode = .time
        timeTF.inputView = timePicker
        let getGesture = UITapGestureRecognizer(target: self, action: #selector(gestureRecognize))
        view.addGestureRecognizer(getGesture)
        timePicker?.addTarget(self, action: #selector(getTime(uiDatePicker:)), for: .valueChanged)
        if #available(iOS 13.4, *){
            timePicker?.preferredDatePickerStyle = .wheels
        }
    }
    
    @objc func gestureRecognize(){
            view.endEditing(true)
    }
    @objc func getTime(uiDatePicker:UIDatePicker){
            let format = DateFormatter()
            format.dateFormat = "HH:mm"
            let currentDate = format.string(from: uiDatePicker.date)
            timeTF.text = currentDate
    }
    
    @IBAction func daySelected(_ sender: Any) {
        print((sender as AnyObject).currentTitle)
        
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        if let name = medicineNameTF.text, let dosage = dosageTF.text, let meal = mealTF.text, let time = timeTF.text {
            saveModel.saveMedicine(medicineName: name, dosage: dosage, meal: meal, time: time)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func saveMedicine(medicineName: String, dosage: String, meal: String, time: String){
        print("\(medicineName)")
    }

}
