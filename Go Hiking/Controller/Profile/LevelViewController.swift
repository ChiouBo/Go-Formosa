//
//  UserContentViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/16.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class LevelViewController: UIViewController {
    
    let icon = ProfileManager()
    
    var userRecord: [UserRecord] = [] {
        
        didSet {
            
            levelTableView.reloadData()
        }
    }
    
    @IBOutlet weak var levelTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getHistoryData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableview()
        
        getHistoryData()
    }
    
    
    func setTableview() {
        
        levelTableView.dataSource = self
        levelTableView.delegate = self
        levelTableView.register(UINib(nibName: "LevelHeadTableViewCell", bundle: nil), forCellReuseIdentifier: "LevelHEAD")
        levelTableView.register(UINib(nibName: "LevelTableViewCell", bundle: nil), forCellReuseIdentifier: "LEVEL")
        levelTableView.rowHeight = UITableView.automaticDimension
        levelTableView.separatorStyle = .none
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

extension LevelViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return icon.userLevelGroup.items.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            guard let headCell = tableView.dequeueReusableCell(withIdentifier: "LevelHEAD", for: indexPath) as? LevelHeadTableViewCell else { return UITableViewCell() }
            headCell.selectionStyle = .none
            
            if userRecord.count == 0 && userRecord.count < 5{
                
                headCell.currentLevelImage.image = UIImage(named: "Icon_Goal_Gray_1")
                headCell.currentLevelTitle.text = "初心者"
                headCell.nextLevelTitle.text = "下一個里程碑：菜鳥山友"
                
            } else if userRecord.count >= 5 && userRecord.count < 10 {
                
                headCell.currentLevelImage.image = UIImage(named: "Icon_Goal_Color_1")
                headCell.currentLevelTitle.text = "菜鳥山友"
                headCell.nextLevelTitle.text = "下一個里程碑：新手山友"
                
            } else if userRecord.count >= 10 && userRecord.count < 20 {
                
                headCell.currentLevelImage.image = UIImage(named: "Icon_Goal_Color_2")
                headCell.currentLevelTitle.text = "新手山友"
                headCell.nextLevelTitle.text = "下一個里程碑：健腳山友"
                
            } else if userRecord.count >= 20 && userRecord.count < 40 {
                
                headCell.currentLevelImage.image = UIImage(named: "Icon_Goal_Color_3")
                headCell.currentLevelTitle.text = "健腳山友"
                headCell.nextLevelTitle.text = "下一個里程碑：癡迷山友"
                
            } else if userRecord.count >= 40 && userRecord.count < 60 {
                
                headCell.currentLevelImage.image = UIImage(named: "Icon_Goal_Color_4")
                headCell.currentLevelTitle.text = "癡迷山友"
                headCell.nextLevelTitle.text = "下一個里程碑：探索老手"
                
            } else if userRecord.count >= 60 && userRecord.count < 80 {
                
                headCell.currentLevelImage.image = UIImage(named: "Icon_Goal_Color_5")
                headCell.currentLevelTitle.text = "探索老手"
                headCell.nextLevelTitle.text = "下一個里程碑：探索高手"
                
            } else if userRecord.count >= 80 && userRecord.count < 100 {
                
                headCell.currentLevelImage.image = UIImage(named: "Icon_Goal_Color_6")
                headCell.currentLevelTitle.text = "探索高手"
                headCell.nextLevelTitle.text = "下一個里程碑：專家"
                
            } else if userRecord.count >= 100 {
                
                headCell.currentLevelImage.image = UIImage(named: "Icon_Goal_Color_7")
                headCell.currentLevelTitle.text = "專家"
                headCell.nextLevelTitle.text = ""
            }
            
            return headCell
        } else {
            
            guard let levelCell = tableView.dequeueReusableCell(withIdentifier: "LEVEL", for: indexPath) as? LevelTableViewCell else { return UITableViewCell() }
            
            levelCell.selectionStyle = .none
            
            if userRecord.count == 0 && userRecord.count < 5 {
                
                levelCell.levelImage.image = icon.userLevelGroup.items[indexPath.row - 1].image
                
            } else if userRecord.count >= 5 && userRecord.count < 10 {
                
                if indexPath.row == 1 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_1")
                } else {
                    levelCell.levelImage.image = icon.userLevelGroup.items[indexPath.row - 1].image
                }
            } else if userRecord.count >= 10 && userRecord.count < 20 {
                
                if indexPath.row == 1 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_1")
                } else if indexPath.row == 2 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_2")
                } else {
                    levelCell.levelImage.image = icon.userLevelGroup.items[indexPath.row - 1].image
                }
            } else if userRecord.count >= 20 && userRecord.count < 40 {
                
                if indexPath.row == 1 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_1")
                } else if indexPath.row == 2 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_2")
                } else if indexPath.row == 3 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_3")
                    
                } else {
                    levelCell.levelImage.image = icon.userLevelGroup.items[indexPath.row - 1].image
                }
                
            } else if userRecord.count >= 40 && userRecord.count < 60 {
                
                if indexPath.row == 1 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_1")
                } else if indexPath.row == 2 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_2")
                } else if indexPath.row == 3 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_3")
                } else if indexPath.row == 4 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_4")
                } else {
                    levelCell.levelImage.image = icon.userLevelGroup.items[indexPath.row - 1].image
                }
                
            } else if userRecord.count >= 60 && userRecord.count < 80 {
                
                if indexPath.row == 1 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_1")
                } else if indexPath.row == 2 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_2")
                } else if indexPath.row == 3 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_3")
                } else if indexPath.row == 4 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_4")
                } else if indexPath.row == 5 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_5")
                } else {
                    levelCell.levelImage.image = icon.userLevelGroup.items[indexPath.row - 1].image
                }
                
            } else if userRecord.count >= 80 && userRecord.count < 100 {
                
                if indexPath.row == 1 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_1")
                } else if indexPath.row == 2 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_2")
                } else if indexPath.row == 3 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_3")
                } else if indexPath.row == 4 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_4")
                } else if indexPath.row == 5 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_5")
                } else if indexPath.row == 6 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_6")
                } else {
                    levelCell.levelImage.image = icon.userLevelGroup.items[indexPath.row - 1].image
                }
                
            } else if userRecord.count >= 100 {
                
                if indexPath.row == 1 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_1")
                } else if indexPath.row == 2 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_2")
                } else if indexPath.row == 3 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_3")
                } else if indexPath.row == 4 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_4")
                } else if indexPath.row == 5 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_5")
                } else if indexPath.row == 6 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_6")
                } else if indexPath.row == 7 {
                    levelCell.levelImage.image = UIImage(named: "Icon_Goal_Color_7")
                }
            }
        levelCell.levelTitle.text = icon.userLevelGroup.items[indexPath.row - 1].title
        levelCell.levelPoint.text = icon.userLevelGroup.items[indexPath.row - 1].desc
        
        return levelCell
    }
}
}
