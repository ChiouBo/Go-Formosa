//
//  StartTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/8.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

protocol StartDateisSelectedDelegate: AnyObject {
    
    func selectedStartDate(_ tableViewCell: StartTableViewCell, date: String)
}

class StartTableViewCell: UITableViewCell {

    weak var delegate: StartDateisSelectedDelegate?
    
    @IBOutlet weak var startLabel: UILabel!
    
    @IBOutlet weak var startDate: UILabel!
    
    @IBOutlet weak var startDateHeight: NSLayoutConstraint!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    @IBAction func selectStartDate(_ sender: UIDatePicker) {
        
        let dateValue = DateFormatter()
        
        dateValue.dateFormat = "yyyy年 MM月 dd日 EE"
        
        self.delegate?.selectedStartDate(self, date: dateValue.string(from: startDatePicker.date))
    }
    
    func setupDatePicker(isSelected: Bool, date: String) {
        
        startLabel.text = "開始時間"
        
        startDate.text = date
        
        if isSelected {
            
            startDateHeight.constant = 200
        } else {
            
            startDateHeight.constant = 0
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
