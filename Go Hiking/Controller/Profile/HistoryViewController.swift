//
//  HistoryViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/16.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    let record = Record.getAllRecords()
    
    var userRecord: [UserRecord] = [] {
        
        didSet {
            
            historyTableView.reloadData()
        }
    }
    
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getHistoryData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        
        getHistoryData()
    }
    
    func setTableView() {
        
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.register(UINib(nibName: "HistoryHeadTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryHEAD")
        historyTableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HISTORY")
        historyTableView.rowHeight = UITableView.automaticDimension
        historyTableView.separatorStyle = .none
    }

    func getHistoryData() {
        
        UserManager.share.loadRecordData { (userRecord) in
            
            switch userRecord {
                
            case .success(let record):
                
                self.userRecord = record
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    

       return userRecord.count + 1
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.row == 0 {
        
        guard let headCell = tableView.dequeueReusableCell(withIdentifier: "HistoryHEAD", for: indexPath) as? HistoryHeadTableViewCell else { return UITableViewCell() }
        
        headCell.selectionStyle = .none
        
        return headCell
    } else {
        
        guard let historyCell = tableView.dequeueReusableCell(withIdentifier: "HISTORY", for: indexPath) as? HistoryTableViewCell else { return UITableViewCell() }
        
        historyCell.selectionStyle = .none
        
        
        guard let asd = Double(userRecord[indexPath.row - 1].distance) else { return UITableViewCell() }
       

        historyCell.exploreTitle.text = "\(asd.roundTo(places: 2))"
        
        historyCell.exploreDate.text = userRecord[indexPath.row - 1].date
        
        return historyCell
        }
    }
    
}

extension Double{
    
    public func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
