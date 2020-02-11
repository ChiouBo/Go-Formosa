//
//  TitleTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/8.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

protocol EventTitleisEdited: AnyObject {
    
    func titleIsEdited(_ tableViewCell: TitleTableViewCell, title: String)
}

class TitleTableViewCell: UITableViewCell {
    
    weak var delegate: EventTitleisEdited?

    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var eventCancel: UIButton!
    
    @IBAction func eventCancel(_ sender: UIButton) {
        
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        titleTextField.delegate = self
    }

}

extension TitleTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        
        self.delegate?.titleIsEdited(self, title: text)
    }
}
