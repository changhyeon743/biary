//
//  UserAPI.swift
//  biary
//
//  Created by 이창현 on 27/02/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class UserAPI {
    func update(completion:@escaping(JSON)->Void) {
        UserAPI.getJSON()
        //        let headers: HTTPHeaders = [
        //            "Content-Type": "application/x-www-form-urlencoded"
        //        ]
        //        let parameters = [
        //            "name" : name,
        //            "facebookId" : facebookId,
        //            "profileURL" : profileURL,
        //            "token" : (token.isEmpty) ? Token.create(length: 15) : token
        //        ]
        //
        //        Alamofire.request("\(API.base_url)/auth/register",method:.post,parameters:parameters,encoding:URLEncoding.httpBody,headers:headers)
        //            .responseJSON(completionHandler: { (response) in
        //                //1. JSON 변환
        //                if let value = response.result.value,response.result.isSuccess {
        //                    completion(JSON(value))
        //                }
        //            })
    }
    
    func fetch(token: String="",completion:@escaping (JSON)->Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters = [
            "token" : (token.isEmpty) ? Token.create(length: 15) : token
        ]
        
        Alamofire.request("\(API.base_url)/fetch",method:.post,parameters:parameters,encoding:URLEncoding.httpBody,headers:headers)
            .responseJSON(completionHandler: { (response) in
                //1. JSON 변환
                if let value = response.result.value,response.result.isSuccess {
                    completion(JSON(value))
                }
            })
        
        
    }
    
    func setUser(fromJSON json:JSON) {
        API.currentUser = User.transformUser(fromJSON: json["user"])
    }
    
    func setBooks(fromJSON json:JSON){
        API.currentBooks = Book.transformBook(fromJSON: json["books"])
        print(API.currentBooks)
    }
    
    func setContents(fromJSON json:JSON){
        API.currentContents = Content.transformContent(fromJSON: json["contents"])
        print(API.currentContents)
    }
    
    static func getJSON() {
        
    }
}