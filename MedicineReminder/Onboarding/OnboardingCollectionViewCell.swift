//
//  OnboardingCollectionViewCell.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 18.09.2024.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var slideDescriptionLabel: UILabel!
    @IBOutlet weak var slideTitleLabel: UILabel!
    @IBOutlet weak var slideImage: UIImageView!
    
    
    func setUp(_ slide: OnboardingSlide){
        slideImage.image = slide.image
        slideTitleLabel.text = slide.title
        slideDescriptionLabel.text = slide.description
        
    }
}
