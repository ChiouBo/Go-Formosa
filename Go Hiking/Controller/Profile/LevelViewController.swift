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
    
    @IBOutlet weak var levelTableView: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableview()
    }
    
    
    func setTableview() {
        
        levelTableView.dataSource = self
        levelTableView.delegate = self
        levelTableView.register(UINib(nibName: "LevelHeadTableViewCell", bundle: nil), forCellReuseIdentifier: "LevelHEAD")
        levelTableView.register(UINib(nibName: "LevelTableViewCell", bundle: nil), forCellReuseIdentifier: "LEVEL")
        levelTableView.rowHeight = UITableView.automaticDimension
        levelTableView.separatorStyle = .none
    }
}

extension LevelViewController: UITableViewDelegate, UITableViewDataSource {
    

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return icon.userLevelGroup.items.count + 1
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.row == 0 {
        
        guard let headCell = tableView.dequeueReusableCell(withIdentifier: "LevelHEAD", for: indexPath) as? LevelHeadTableViewCell else { return UITableViewCell() }
        
        return headCell
    } else {
        
        guard let levelCell = tableView.dequeueReusableCell(withIdentifier: "LEVEL", for: indexPath) as? LevelTableViewCell else { return UITableViewCell() }
        
        levelCell.levelImage.image = icon.userLevelGroup.items[indexPath.row - 1].image
        levelCell.levelTitle.text = icon.userLevelGroup.items[indexPath.row - 1].title
        levelCell.levelPoint.text = icon.userLevelGroup.items[indexPath.row - 1].desc
        
        return levelCell
        }
    }
    
}


