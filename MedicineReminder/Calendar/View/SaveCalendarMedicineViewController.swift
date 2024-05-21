//
//  SaveCalendarMedicineViewController.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 14.05.2024.
//

import UIKit
import UserNotifications
class SaveCalendarMedicineViewController: UIViewController, UITextFieldDelegate {

    var saveModel = SaveCalendarViewModel()
    
    @IBOutlet weak var medicineNameTF: UITextField!
    @IBOutlet weak var dosageTF: UITextField!
    @IBOutlet weak var mealTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    var timePicker: UIDatePicker?
    var permission = false
    
    var selectedDays: [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        timePicker = UIDatePicker()
        timePicker?.datePickerMode = .time
        timeTF.inputView = timePicker
        timeTF.delegate = self
        medicineNameTF.delegate = self
        dosageTF.delegate = self
        mealTF.delegate = self

        let getGesture = UITapGestureRecognizer(target: self, action: #selector(gestureRecognize))
        view.addGestureRecognizer(getGesture)
        timePicker?.addTarget(self, action: #selector(getTime(uiDatePicker:)), for: .valueChanged)
        if #available(iOS 13.4, *){
            timePicker?.preferredDatePickerStyle = .wheels
        }
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gestureRecognize))
        view.addGestureRecognizer(tapGesture)
      
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    
    //MARK: Time
    @objc func gestureRecognize(){
            view.endEditing(true)
    }
    @objc func getTime(uiDatePicker:UIDatePicker){
            let format = DateFormatter()
            format.dateFormat = "HH:mm"
            let currentDate = format.string(from: uiDatePicker.date)
            timeTF.text = currentDate
    }
    
    
    //MARK: Selected Days
    @IBAction func daySelected(_ sender: UIButton) {
        guard let day = sender.currentTitle else { return }
        
        if sender.backgroundColor == UIColor.black {
            sender.backgroundColor = UIColor(named: "Color 1")
            if let index = selectedDays.firstIndex(of: day) {
                selectedDays.remove(at: index)
            }
        } else {
            sender.backgroundColor = UIColor.black
            if !selectedDays.contains(day) {
                selectedDays.append(day)
            }
        }
        print(selectedDays)
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
       
        if let name = medicineNameTF.text, let dosage = dosageTF.text, let meal = mealTF.text, let time = timeTF.text, !selectedDays.isEmpty {
               saveModel.saveMedicine(medicineName: name, dosage: dosage, meal: meal, time: time, medDay: selectedDays)
           }
           dismiss(animated: true, completion: nil)
    }
   


}


extension SaveCalendarMedicineViewController{
    func textFieldDidBeginEditing(_ textField: UITextField) {
           if textField == timeTF {
               if self.view.frame.origin.y == 0 {
                   UIView.animate(withDuration: 0.3) {
                       self.view.frame.origin.y = -150
                   }
               }
           }
       }
       
       func textFieldDidEndEditing(_ textField: UITextField) {
           if textField == timeTF {
               if self.view.frame.origin.y != 0 {
                   UIView.animate(withDuration: 0.3) {
                       self.view.frame.origin.y = 0
                   }
               }
           }
       }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           if textField == medicineNameTF {
               dosageTF.becomeFirstResponder()
           } else if textField == dosageTF {
               mealTF.becomeFirstResponder()
           } else if textField == mealTF {
               timeTF.becomeFirstResponder()
           } else if textField == timeTF {
               textField.resignFirstResponder()
           }
           return true
       }
}
