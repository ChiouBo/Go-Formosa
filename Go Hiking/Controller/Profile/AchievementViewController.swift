//
//  AchievementViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/16.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class AchievementViewController: UIViewController {

    @IBOutlet weak var achieveTableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableview()
    }
    
    func setTableview() {
        
        achieveTableView.dataSource = self
        achieveTableView.delegate = self
        achieveTableView.register(UINib(nibName: "AchieveHeadTableViewCell", bundle: nil), forCellReuseIdentifier: "AchieveHEAD")
        achieveTableView.register(UINib(nibName: "AchieveTableViewCell", bundle: nil), forCellReuseIdentifier: "ACHIEVE")
        achieveTableView.rowHeight = UITableView.automaticDimension
        achieveTableView.separatorStyle = .none
    }

}

extension AchievementViewController: UITableViewDelegate, UITableViewDataSource {
    

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 2
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.row == 0 {
        
        guard let headCell = tableView.dequeueReusableCell(withIdentifier: "AchieveHEAD", for: indexPath) as? AchieveHeadTableViewCell else { return UITableViewCell() }
        
        headCell.selectionStyle = .none
        
        return headCell
    } else {
        
        guard let achieveCell = tableView.dequeueReusableCell(withIdentifier: "ACHIEVE", for: indexPath) as? AchieveTableViewCell else { return UITableViewCell() }
        
        achieveCell.selectionStyle = .none
        
        return achieveCell
        }
    }
    
}
