//
//  PersonTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/8.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    @IBOutlet weak var personTitle: UILabel!
    
    @IBOutlet weak var personAmount: UILabel!
    
    @IBOutlet weak var switchAmount: UISwitch!
    
    @IBAction func switchAmount(_ sender: UISwitch) {
    }
    
    @IBOutlet weak var amountPickerView: UIPickerView!
    
    @IBOutlet weak var amountHeight: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
