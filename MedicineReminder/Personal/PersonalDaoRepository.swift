//
//  PersonalDaoRepository.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 19.05.2024.
//

import Foundation
import RxSwift
import FirebaseFirestore
import UserNotifications
import FirebaseAuth

class PersonalDaoRepository{
    
    var personList = BehaviorSubject<[Person]>(value: [Person]())
    var collectionPerson = Firestore.firestore().collection("personal")
    
    func save(name: String, weight: String, height: String, dob: String){
        let person:[String:Any] = ["id":"" , "name":name, "weight":weight, "height":height, "dob":dob, "username": Auth.auth().currentUser!.email!]
        collectionPerson.document().setData(person)
    }
    
    func loadData(){
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let user = currentUser.email
        
        collectionPerson.whereField("username", isEqualTo: user!).addSnapshotListener{ snapshot, error in
            var list = [Person]()
            if let documents = snapshot?.documents{
                for document in documents{
                    let data = document.data()
                    let id = document.documentID
                    let name = data["name"] as? String ?? ""
                    let weight = data["weight"] as? String ?? ""
                    let height = data["height"] as? String ?? ""
                    let dob = data["dob"] as? String ?? ""
                    
                    let birth = dob.split(separator: "/")
                    let year = Int(birth[2])
                    
                    let currentYear = Calendar.current.component(.year, from: Date())
                    let age = currentYear - year!
                    
                    
                    let person = Person(id: id, username: name, weight: weight, height: height, DoB: dob, age: age)
                    
                  
                    print(currentYear)
                    print(year)
                    print(age)
                     
                    list.append(person)
                }
            }
            self.personList.onNext(list)
        }
        
    }
    
   
    
}
