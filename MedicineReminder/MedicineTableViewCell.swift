//
//  MedicineTableViewCell.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 28.04.2024.
//

import UIKit

class MedicineTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var medicineImageView: UIImageView!
    @IBOutlet weak var nameMedicineLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
