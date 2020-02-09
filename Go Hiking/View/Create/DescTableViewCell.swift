//
//  DescTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/8.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

protocol EventDESCisEdited: AnyObject {
    
    func descIsEdited(_ tableViewCell: DescTableViewCell, desc: String)
}

class DescTableViewCell: UITableViewCell {

    weak var delegate: EventDESCisEdited?
    
    @IBOutlet weak var eventDesc: UILabel!
    
    @IBOutlet weak var DescTextView: KMPlaceholderTextView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DescTextView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        DescTextView.delegate = self
    }
    
}

extension DescTableViewCell: UITextViewDelegate{
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard let text = textView.text else { return }
        
        self.delegate?.descIsEdited(self, desc: text)
    }
}
