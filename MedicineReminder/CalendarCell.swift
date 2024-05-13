//
//  CalendarCell.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 12.05.2024.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var dayOfMonth: UILabel!
    override func layoutSubviews() {
            super.layoutSubviews()
            setupCellAppearance()
        }
        

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellAppearance()
    }
    
    func setupCellAppearance() {
        // Hücrenin arka plan rengini kırmızı yap
        self.backgroundColor = UIColor(named: "color")
        
        // Hafif yuvarlaklık eklemek için köşeleri yuvarlat
        self.layer.cornerRadius = 10 // Örneğin, 10 birimlik bir yuvarlaklık
        
        // Köşelerin kesilmesini önle
        self.clipsToBounds = true
    }

//
//       func setSelectedAppearance(selected: Bool) {
//           if selected {
//               // Seçilen hücrenin arka plan rengini mavi yap
//               self.backgroundColor = UIColor.blue
//           } else {
//               // Diğer hücrelerin arka plan rengini yeşil yap
//               self.backgroundColor = UIColor.green
//           }
//       }
    
    
}
