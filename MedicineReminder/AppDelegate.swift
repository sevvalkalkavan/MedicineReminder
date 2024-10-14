//
//  AppDelegate.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 27.04.2024.
//

import UIKit
import FirebaseCore

import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


   lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "Model")
       container.loadPersistentStores(completionHandler: { (storeDescription,error) in
           if let e = error {
               print("Hata : \((e as NSError).userInfo)")
           }
       })
       return container
   }()
   
   func saveContext(){
       let context = persistentContainer.viewContext
       if context.hasChanges {
           do{
               try context.save()
           }catch{
               print("Hata  : \((error as NSError).userInfo)")
           }
       }
   }

   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
   /*     let tabBarController = UITabBarController()
        let favoritesVC = CalendarViewController()
        favoritesVC.title = "Favorites"
        favoritesVC.view.backgroundColor = UIColor.orange
        let downloadsVC = MedicineViewController()
        downloadsVC.title = "Downloads"
        downloadsVC.view.backgroundColor = UIColor.blue
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        downloadsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
        let controllers = [favoritesVC, downloadsVC]
        tabBarController.viewControllers = controllers
        tabBarController.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
      */
        
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

