//
//  TrailManager.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/3.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import Alamofire

protocol TrailResponseDelegate: AnyObject {
    
    func response(_ response: TrailResponse, get trailListData: [Trail])
}

class TrailResponse {
    
    weak var delegate: TrailResponseDelegate?
    
    func getTrailListData() {
        
        guard let url = URL(string: "https://recreation.forest.gov.tw/mis/api/BasicInfo/Trail") else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                
                print(error.localizedDescription)
                
            }
            
            guard let jsonData = data else { return }
            
            do {
                let user = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                
                let dataResponse = try JSONDecoder().decode(AllTrail.self, from: jsonData)
                
                self.delegate?.response(self, get: dataResponse)
                
                print(user)
                print(dataResponse)
                
            } catch {
                
                print(error)
            }
        }
        task.resume()
    }

}
