//
//  CalendarMedicineTableViewCell.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 13.05.2024.
//

import UIKit

class CalendarMedicineTableViewCell: UITableViewCell {

    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var medicineDosageLabel: UILabel!
    @IBOutlet weak var medicineMealLabel: UILabel!
    @IBOutlet weak var medicineTimeLabel: UILabel!
    @IBOutlet weak var cellBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
