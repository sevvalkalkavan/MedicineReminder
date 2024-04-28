//
//  ViewController.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 27.04.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var AppNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        AppNameLabel.text = ""
        var charIndex = 0.0
        let titleText = "Take2Heal"
        AppNameLabel.font = UIFont(name: "PatuaOne-Regular", size: 40)
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false){ (timer) in
                self.AppNameLabel.text?.append(letter)
            }
            charIndex += 1
        }

        

    }
    
    
    @IBAction func buttonLogin(_ sender: Any) {
    }
    
    @IBAction func buttonSignup(_ sender: Any) {
    }
    
}

