//
//  PersonTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/8.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

protocol PersonSelectedDelegate: AnyObject {
    
    func selectedPerson(_ tableViewCell: PersonTableViewCell, amount: String)
}


class PersonTableViewCell: UITableViewCell {
    
    weak var delegate: PersonSelectedDelegate?

    @IBOutlet weak var personTitle: UILabel!
    
    @IBOutlet weak var personAmount: UILabel!
    
    @IBOutlet weak var switchAmount: UISwitch!
    
    @IBAction func switchAmount(_ sender: UISwitch) {
        
        if sender.isOn == true {
            
            setupAmountPicker(isSelected: true, amount: "\(String(describing: personAmount))")
        } else {
            
            setupAmountPicker(isSelected: false, amount: "不限")
        }
        
    }
    
    @IBOutlet weak var amountPickerView: UIPickerView!
    
    @IBOutlet weak var amountHeight: NSLayoutConstraint!
    

    func setupAmountPicker(isSelected: Bool, amount: String) {
        
        personTitle.text = "參加人數"
        
        personAmount.text = amount
        
        if switchAmount.isOn == true && isSelected == true {
            
            amountHeight.constant = 150
            
        } else if switchAmount.isOn == false || isSelected == false {
            
            amountHeight.constant = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
