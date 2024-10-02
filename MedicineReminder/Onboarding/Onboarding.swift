//
//  Onboarding.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 18.09.2024.
//

import UIKit

class Onboarding: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var slides: [OnboardingSlide] = [
        OnboardingSlide(title: "Never Miss a Dose!", description: "Get timely reminders to take your medications and stay on track.", image: UIImage(named: "app")!),
        OnboardingSlide(title: "Virtual Pillbox", description: "Record meds, monitor expiration dates, and manage doses easily.", image: UIImage(named: "6673749_emergency_health_healthcare_hospital_kit_icon")!),
        OnboardingSlide(title: "Create Your Personal Account", description: "Create an account to track medications and reminders across devices.", image: UIImage(named: "H-8")!)
    ]
    
    var currentPage = 0 {
        didSet{
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1{
                nextButton.setTitle("Get Started", for: .normal)
                
            }else{
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    @IBAction func clickedNextButton(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            let tabBarController = storyboard?.instantiateViewController(identifier: "tabBar") as! UITabBarController

            tabBarController.modalPresentationStyle = .fullScreen
            tabBarController.modalTransitionStyle = .flipHorizontal
               present(tabBarController, animated: true, completion: nil)
           } else {
               currentPage += 1
               collectionView.isPagingEnabled = false
               let indexPath = IndexPath(item: currentPage, section: 0)
               collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
               collectionView.isPagingEnabled = true
           }
    }
    
        
    }
    


extension Onboarding: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.setUp(slides[indexPath.row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
       
    }
    
}
