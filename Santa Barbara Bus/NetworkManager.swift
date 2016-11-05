//
//  NetworkManager.swift
//  Santa Barbara Bus
//
//  Created by Bjarte Sjursen on 29/10/16.
//  Copyright © 2016 Bjarte Sjursen. All rights reserved.
//

//
//  NetworkManager.swift
//  Dots
//
//  Created by Bjarte Sjursen on 30.07.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import Foundation

let apiWebAdress = ""

class NetworkManager {
    
    /*
    static func registerUser(username : String, password : String, completionHandler : (_ data : NSData?, _ response : URLResponse?, _ error : NSError?) -> Void){
        do{
            let urlRequest = NSMutableURLRequest(URL: NSURL(string: apiWebAdress + "register")! as URL)
            urlRequest.HTTPMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let post = ["username":username, "password":password]
            let postData = try JSONSerialization.dataWithJSONObject(post, options: .prettyPrinted)
            urlRequest.HTTPBody = postData
            dispatchURLRequest(urlRequest, completionHandler: completionHandler)
        } catch{
            print("Could not construct the necessary data")
        }
    }*/
    
    static func dispatchURLRequest(urlRequest : NSMutableURLRequest, completionHandler : @escaping (_ data : NSData?, _ response : URLResponse?, _ error : NSError?) -> Void){
        
        DispatchQueue(label: "networkQueue").async(execute: {
            
            URLSession.shared.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
                completionHandler(data as NSData?, response, error as NSError?)
            }).resume()
        
        })
    }

    
    
}

