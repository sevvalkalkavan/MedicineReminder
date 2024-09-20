//
//  TabBarViewController.swift
//  MedicineReminder
//
//  Created by Şevval Kalkavan on 20.09.2024.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
    
        if let items = self.tabBar.items {
            if let viewTabBar = items[2].value(forKey: "view") as? UIView {
                if viewTabBar.subviews.count == 2 {
                    if let label = viewTabBar.subviews[1] as? UILabel {
                        label.numberOfLines = 2
                        label.textAlignment = .center
                        label.text = NSLocalizedString("tab_point", comment: "Tab Bar Label")
                    }
                    items[2].imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -5, right: 0)
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
