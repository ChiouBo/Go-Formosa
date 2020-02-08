//
//  EndTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/8.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

protocol EndDateisSelectedDelegate: AnyObject {
    
    func selectedEndDate(_ tableViewCell: EndTableViewCell, date: String)
}

class EndTableViewCell: UITableViewCell {

    weak var delegate: EndDateisSelectedDelegate?
    
    @IBOutlet weak var endLabel: UILabel!
    
    @IBOutlet weak var endDate: UILabel!
    
    @IBOutlet weak var endDateHeight: NSLayoutConstraint!
    
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBAction func selectEndDate(_ sender: UIDatePicker) {
        
        let dateValue = DateFormatter()
        
        dateValue.dateFormat = "yyyy年 MM月 dd日 EE"
        
        self.delegate?.selectedEndDate(self, date: dateValue.string(from: endDatePicker.date))
    }
    
    func setupDatePicker(isSelected: Bool, date: String) {
        
        endLabel.text = "結束時間"
        
        endDate.text = date
        
        if isSelected {
            
            endDateHeight.constant = 200
        } else {
            
            endDateHeight.constant = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
