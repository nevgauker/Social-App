//
//  AylienAPI-networking.swift
//  Social-App
//
//  Created by rotem nevgauker on 6/10/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class AylienAPI_networking: NSObject {
    
    static let sharedInstance = AylienAPI_networking()
    
    let Application_Key = "99b8b3ad67527c5d81e95c854adad3e0"
    let Application_ID = "6370b677"
    let base_url:String = "https://api.aylien.com/api/v1/"
   
    
    //for combine api calls
    let combined_module:String = "combined"
    //suport combine api calls
    let modules:[String: String] = ["sentiment_module" : "sentiment", "summarize_module" : "summarize", "concepts_module" : "concepts" , "entities_module" : "entities", "hashtags_module" : "hashtags"]
    
    //do not support combine api calls
    
    let classify_module:String = "classify"
    let elsa_module:String = "elsa"
    
  //  let texonomy_module:String = "classify/:taxonomy"
    
    func combineCall(text:String,post_id:String,  completion: @escaping (Bool) -> ()) {
        
        let urlString = base_url + combined_module
        
        
        let endpointsArr:[String] = Array(modules.values)
        
        
        let defaultHeaders = ["X-AYLIEN-TextAPI-Application-Key": Application_Key,"X-AYLIEN-TextAPI-Application-ID" : Application_ID, "Accept" : "application/json", "content-type" : "application/x-www-form-urlencoded"]
        let params:[String: Any] = ["text" : text, "endpoint" : endpointsArr]
        Alamofire.request(urlString, method: .post, parameters:params, encoding: URLEncoding.httpBody, headers: defaultHeaders).responseJSON {
            response in
            switch response.result {
            case .success:
                if response.data != nil {
                    let json = try? JSON(data: response.data!)
                    if let responseJSON = json {
                        Networking.sharedInstance.updatePostInsights(post_id: post_id, resposeJSON: responseJSON)
                    }
                    
                }
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func classify(text:String, completion: @escaping (Bool) -> ()) {
        
        let urlString = base_url + modules["classify_module"]!
        let defaultHeaders = ["X-AYLIEN-TextAPI-Application-Key": Application_Key,"X-AYLIEN-TextAPI-Application-ID" : Application_ID, "Accept" : "application/json", "content-type" : "application/x-www-form-urlencoded"]
        let params:[String: String] = ["text" : text]
        Alamofire.request(urlString, method: .post, parameters:params, encoding: URLEncoding.httpBody, headers: defaultHeaders).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}
