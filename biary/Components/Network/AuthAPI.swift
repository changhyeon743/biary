//
//  AuthAPI.swift
//  biary
//
//  Created by 이창현 on 25/02/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthAPI {
    func register( name: String, facebookId: String, profileURL: String,token: String="",completion:@escaping (JSON)->Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters = [
            "name" : name,
            "facebookId" : facebookId,
            "profileURL" : profileURL,
            "token" : (token.isEmpty) ? Token.create() : token
        ]
        
        Alamofire.request("\(API.base_url)/auth/register",method:.post,parameters:parameters,encoding:URLEncoding.httpBody,headers:headers)
            .responseJSON(completionHandler: { (response) in
                //1. JSON 변환
                if let value = response.result.value,response.result.isSuccess {
                    completion(JSON(value))
                }
            })
        
        
    }
    
    
    
    
}

