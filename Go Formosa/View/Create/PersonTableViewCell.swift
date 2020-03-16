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
    
    func didTap(_ tableViewCell: PersonTableViewCell)
}

class PersonTableViewCell: UITableViewCell {
    
    weak var delegate: PersonSelectedDelegate?
    
    @IBOutlet weak var personTitle: UILabel!
    
    @IBOutlet weak var personAmount: UILabel!
    
    @IBOutlet weak var switchAmount: UISwitch!
    
    @IBAction func switchAmount(_ sender: UISwitch) {
        
        counter += 1

        if sender.isOn == true {

            setupAmountPicker(counter: counter, isSelected: true, amount: "")
            self.delegate?.selectedPerson(self, amount: "")
        } else {

            setupAmountPicker(counter: counter, isSelected: true, amount: "不限")
            self.delegate?.selectedPerson(self, amount: "不限")
        }

        self.delegate?.didTap(self)
    }
    
    @IBOutlet weak var amountPickerView: UIPickerView!
    
    @IBOutlet weak var amountHeight: NSLayoutConstraint!
    
    var counter = 0
    
    func setupAmountPicker(counter: Int, isSelected: Bool, amount: String) {
        
        personTitle.text = "人數上限"
        
//        self.amount = amount
        
        personAmount.text = amount
        
        if switchAmount.isOn == true && isSelected == true {
            
            amountHeight.constant = 200
            
        } else if switchAmount.isOn == false || isSelected == false {
            
            if counter == 0 {
                
                personAmount.text = ""
            } else {
                personAmount.text = amount
            }
            amountHeight.constant = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
