//
//  MeaningCloud.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/27/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit
import Alamofire


class MeaningCloud: NSObject {
    static let sharedInstance = MeaningCloud()
    
    let topicsEndPoint = "https://api.meaningcloud.com/topics-2.0"
    
      func topics(txt:String, completion: @escaping (Bool) -> ()) {
        
        let defaultHeaders = [ "content-type" : "application/x-www-form-urlencoded", "Accept" : "application/json"]
        let params = ["key" : "675eee92a0052e52b9f7943d02434f9c", "lang" : "en","tt" : "a", "txt" : txt]
        Alamofire.request(topicsEndPoint, method: .post, parameters: params, encoding: URLEncoding.httpBody ,headers: defaultHeaders).responseJSON { response in
            switch response.result {
                case .success:
                    print(response)
                    break
                case .failure(let error):
    
                    print(error)
            }
        }
    }
}
