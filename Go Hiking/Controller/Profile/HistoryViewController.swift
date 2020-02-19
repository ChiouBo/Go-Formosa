//
//  HistoryViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/16.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.register(UINib(nibName: "HistoryHeadTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryHEAD")
        historyTableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HISTORY")
        historyTableView.rowHeight = UITableView.automaticDimension
    }
    

  
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    
    return 10
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.row == 0 {
        
        guard let headCell = tableView.dequeueReusableCell(withIdentifier: "HistoryHEAD", for: indexPath) as? HistoryHeadTableViewCell else { return UITableViewCell() }
        
        return headCell
    } else {
        guard let historyCell = tableView.dequeueReusableCell(withIdentifier: "HISTORY", for: indexPath) as? HistoryTableViewCell else { return UITableViewCell() }
        
        return historyCell
        }
    }
    
}
