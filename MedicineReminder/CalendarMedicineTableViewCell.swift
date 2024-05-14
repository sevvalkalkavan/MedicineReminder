//
//  CalendarMedicineTableViewCell.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 14.05.2024.
//

import UIKit

class CalendarMedicineTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
