//
//  AchievementViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/16.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

//enum CellType {
//
//    case distance
//
//    case time
//
//    case height
//
//    case easy
//
//    case medium
//
//    case hard
//
//    case leader
//}
//
//struct jim {
//
//    var type: CellType
//
//    var title: String
//
//}

class AchievementViewController: UIViewController {

    var userRecord: [UserRecord] = [] {
        
        didSet {
            
            achieveTableView.reloadData()
        }
    }
    
    var farthest: [Double] = []
    
    var oldest: [Int] = []
    
//    var qaq: [jim] = [jim(type: .distance, title: ""),
//                      jim(type: .time, title: ""),
//                      jim(type: .height, title: ""),
//                      jim(type: .easy, title: ""),
//                      jim(type: .medium , title: ""),
//                      jim(type: .hard , title: ""),
//                      jim(type: .leader, title: "")]
    
    @IBOutlet weak var achieveTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getHistoryData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableview()
        
//        getHistoryData()
    }
    
    func setTableview() {
        
        achieveTableView.dataSource = self
        achieveTableView.delegate = self
        achieveTableView.register(UINib(nibName: "AchieveHeadTableViewCell", bundle: nil), forCellReuseIdentifier: "AchieveHEAD")
        achieveTableView.register(UINib(nibName: "AchieveTableViewCell", bundle: nil), forCellReuseIdentifier: "ACHIEVE")
        achieveTableView.rowHeight = UITableView.automaticDimension
        achieveTableView.separatorStyle = .none
    }
    
    func getHistoryData() {
        
        UserManager.share.loadRecordData { [weak self] (userRecord) in
            
            switch userRecord {
                
            case .success(let record):
                
                self?.userRecord = record
                
                for distance in record {
                    self?.farthest.append(distance.distance)
                }
                self?.farthest = self?.farthest.sorted { $0 > $1 } ?? [0.0]

                for time in record {
                    self?.oldest.append(time.time)
                }
                self?.oldest = self?.oldest.sorted { $0 > $1 } ?? [0]
                
            case .failure(let error):
                
                print(error)
            }
        }
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
        
//        if farthest.isEmpty {
//            headCell.achieveDesc.text = "0.0 公里"
//        } else {
//            headCell.achieveDesc.text = "\(farthest[0]) 公里"
//        }
//
//        if oldest.isEmpty {
//
//            headCell.achieveDesc.text = "0.0 小時"
//        } else {
//
//            headCell.achieveDesc.text = "\(oldest[0] / 3600).\(Int((oldest[0] % 3600) / 360)) 小時"
//        }

        
        return headCell
    } else {
        
        guard let achieveCell = tableView.dequeueReusableCell(withIdentifier: "ACHIEVE", for: indexPath) as? AchieveTableViewCell else { return UITableViewCell() }
        
        achieveCell.selectionStyle = .none
        
        return achieveCell
        }
    }
    
}
