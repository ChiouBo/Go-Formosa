//
//  ContentViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/24.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var contentImage: UIImageView!
    
    @IBOutlet weak var contentTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setElement()
    }
    
    func setElement() {
        
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.rowHeight = UITableView.automaticDimension
    }


}

extension ContentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Content", for: indexPath) as? ContentTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    

    
}
