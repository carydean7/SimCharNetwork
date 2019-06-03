//
//  Character.swift
//  SimpsonsCharacterViewer
//
//  Created by Dean Wagstaff on 5/17/19.
//  Copyright © 2019 Dean Wagstaff. All rights reserved.
//

import UIKit

public class Character: NSObject {
    typealias JSONDictionary = [String: Any]
    
    let restNetworkManager = RestNetworkManager()
    
    override init() {
        super.init()
    }
    
    func fetchData(with url:String, completion: @escaping ([NSDictionary]?) -> Void) {
        guard let url = URL(string: url) else { return }
        
        restNetworkManager.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            if let data = results.data {
                var errorMessage = ""
                
                do {
                    if let response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary {
                        // Create an array of dictionaries from response
                        // set completion handler with array of dictionaries
                        completion((response["RelatedTopics"] as! [[String: Any]] as [NSDictionary]))
                    }
                } catch let parseError as NSError {
                    errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
                    completion(nil)
                    return
                }
            }
        }
    }
    
    func fetchImage(from url: String, completion: @escaping (UIImageView?) -> Void) {
        guard let url = URL(string: url) else {
            return
        }

        restNetworkManager.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            if let data = results.data {
                do {
                    DispatchQueue.main.sync {
                        let image = UIImage(data: data)
                        let iv = UIImageView(frame: CGRect(x: 90, y: 200, width: 200, height: 200))
                        iv.layer.borderWidth = 3
                        iv.layer.borderColor = UIColor.blue.cgColor
                        iv.image = image
                        
                        completion(iv)
                    }
                }
            }
        }
    }
}
