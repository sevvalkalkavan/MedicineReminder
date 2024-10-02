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
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var personalViewModel = PersonalViewModel()
    var personList = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //eğer kullancıı giriş yapmadıysa logOut yazısı yerine login yazısı gözüksün login sayfasına atasın
        //eğer kullancıı giriş yapmadıysa logOut yazısı yerine signup yazısı gözüksün signup sayfasına atasın

        if let user = Auth.auth().currentUser {
            
        }else{
            logOutButton.setTitle("Log in", for: .normal)
            deleteButton.setTitle("Sign up", for: .normal)
        }
        
        
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
        
        guard let button = sender as? UIButton else { return }
           let buttonTitle = button.title(for: .normal)
        
        if buttonTitle == "Log Out" {
            do {
                   try Auth.auth().signOut()
                   
                   // Uygulamanın kök ekranını (rootViewController) değiştirmek
                   if let window = UIApplication.shared.windows.first {
                       let storyboard = UIStoryboard(name: "Main", bundle: nil)
                       let homeNC = storyboard.instantiateViewController(withIdentifier: "homeNC") as! UINavigationController
                       window.rootViewController = homeNC
                       window.makeKeyAndVisible()
                       
                       // Geri dönüş animasyonu
                       UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
                   }
                   
               } catch {
                   print("Error signing out: \(error.localizedDescription)")
               }
        }else if buttonTitle == "Log in"{
            if let window = UIApplication.shared.windows.first {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LogInViewController
                window.rootViewController = mainVC
                window.makeKeyAndVisible()
                
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            }
        }
        
      
           
        }
        
        
        
        
    
    
    @IBAction func deleteAccountButton(_ sender: Any) {
        
        
        //eğer kullancıı giriş yapmadıysa logOut yazısı yerine signup yazısı gözüksün signup sayfasına atasın
        
        guard let button = sender as? UIButton else { return }
           let buttonTitle = button.title(for: .normal)
        
        if buttonTitle == "Delete account"{
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
                                        if let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") {
                                            mainVC.modalPresentationStyle = .fullScreen
                                            self.present(mainVC, animated: true, completion: nil)
                                        }
                                       
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
        }else if buttonTitle == "Sign up"{
            if let window = UIApplication.shared.windows.first {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainVC = storyboard.instantiateViewController(withIdentifier: "signupVC") as! SignUpViewController
                window.rootViewController = mainVC
                window.makeKeyAndVisible()
                
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            }
        }
        
       
        
    }
}
