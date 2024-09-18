import Foundation
import RxSwift
import FirebaseFirestore
import FirebaseAuth

class PersonalDaoRepository {
    
    var personList = BehaviorSubject<[Person]>(value: [Person]())
    private var collectionPerson = Firestore.firestore().collection("personal")
    
    func save(name: String, weight: String, height: String, dob: String) {
        let person: [String: Any] = [
            "id": "",
            "name": name,
            "weight": weight,
            "height": height,
            "dob": dob,
            "username": Auth.auth().currentUser!.email!
        ]
        collectionPerson.document().setData(person)
    }
    
    func deleteData(completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }

        let userEmail = currentUser.email ?? ""
        
        collectionPerson.whereField("username", isEqualTo: userEmail).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(error)
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete { error in
                        if let error = error {
                            print("Error removing document: \(error)")
                            completion(error)
                        } else {
                            print("Document successfully removed!")
                            completion(nil)
                        }
                    }
                }
            }
        }
    }

    
    func loadData() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let user = currentUser.email ?? ""
        
        collectionPerson.whereField("username", isEqualTo: user).addSnapshotListener { snapshot, error in
            var list = [Person]()
            if let documents = snapshot?.documents {
                for document in documents {
                    let data = document.data()
                    let id = document.documentID
                    let name = data["name"] as? String ?? ""
                    let weight = data["weight"] as? String ?? ""
                    let height = data["height"] as? String ?? ""
                    let dob = data["dob"] as? String ?? ""
                    
                    let birth = dob.split(separator: "/")
                    let year = Int(birth[2]) ?? 0
                    
                    let currentYear = Calendar.current.component(.year, from: Date())
                    let age = currentYear - year
                    
                    let person = Person(id: id, username: name, weight: weight, height: height, DoB: dob, age: age)
                    
                    list.append(person)
                }
            }
            self.personList.onNext(list)
        }
    }
    
    func errorAlert(titleInput: String, messageInput: String, viewController: UIViewController) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        viewController.present(alert, animated: true, completion: nil)
    }
}
