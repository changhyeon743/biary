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
    func getRandomBook(query:String, completion:@escaping (JSON)->Void) {
        print("\(API.base_url)/book/random?query="+query)
        let parameters = [
            "query" : query,
        ]
        
        AF.request("\(API.base_url)/book/random", method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: nil).responseJSON { (response) in
            if let value = response.value {
                completion(JSON(value))
            }
        }
        
        
        
    }
    
    func register(name: String, facebookId: String, profileURL: String, token: String,completion:@escaping(JSON)->Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters = [
            "name" : name,
            "facebookId" : facebookId,
            "profileURL" : profileURL,
            "token" : token
        ]
        
        AF.request("\(API.base_url)/auth/register",method:.post,parameters:parameters,encoding:URLEncoding.httpBody,headers:headers)
            .responseJSON(completionHandler: { (response) in
                //1. JSON 변환
                if let value = response.value {
                    completion(JSON(value))
                }
            })
    }
    
    func logoutUpdate() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        encoder.dateEncodingStrategy = .formatted(formatter)
        
        let user = try? encoder.encode(Complete_data.make())
        
        if let str = user, let jsonString = String(data: str, encoding: .utf8) {
            //print("logout.. json??",jsonString)
            let headers: HTTPHeaders = [
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            //print(jsonString)
            let parameters = [
                "data" : jsonString
            ]
            
            AF.request("\(API.base_url)/update",method:.post,parameters:parameters,encoding:URLEncoding.httpBody,headers:headers)
                .responseJSON(completionHandler: { (response) in
                    //1. JSON 변환
                })
            
        }
    }
    
    func update() {
        if (API.currentUser.isLogined) {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            encoder.dateEncodingStrategy = .formatted(formatter)
            let user = try? encoder.encode(Complete_data.make())
            
            
            if let str = user, let jsonString = String(data: str, encoding: .utf8) {
                //print("update.. json??",jsonString)

                let headers: HTTPHeaders = [
                    "Content-Type": "application/x-www-form-urlencoded"
                ]
                //print(jsonString)
                let parameters = [
                    "data" : jsonString
                ]
                print(jsonString)
                
                AF.request("\(API.base_url)/update",method:.post,parameters:parameters,encoding:URLEncoding.httpBody,headers:headers)
                    .responseJSON(completionHandler: { (response) in
                        //1. JSON 변환
                    })
                
            }
        }
        
    }
    
    func update(completion:@escaping(JSON)->Void) {
        if (API.currentUser.isLogined) {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            encoder.dateEncodingStrategy = .formatted(formatter)
            let user = try? encoder.encode(Complete_data.make())
            
            
            if let str = user, let jsonString = String(data: str, encoding: .utf8) {
                let headers: HTTPHeaders = [
                    "Content-Type": "application/x-www-form-urlencoded"
                ]
                //print(jsonString)
                let parameters = [
                    "data" : jsonString
                ]
                
                AF.request("\(API.base_url)/update",method:.post,parameters:parameters,encoding:URLEncoding.httpBody,headers:headers)
                    .responseJSON(completionHandler: { (response) in
                        //1. JSON 변환
                        if let value = response.value {
                            completion(JSON(value))
                        }
                    })
                
            }
        }
        
    }
    
    func isLogined(facebookId: String="",completion:@escaping (JSON)->Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters = [
            "facebookId": facebookId
        ]
        
        AF.request("\(API.base_url)/auth/isLogined",method:.post,parameters:parameters,encoding:URLEncoding.httpBody,headers:headers)
            .responseJSON(completionHandler: { (response) in
                //1. JSON 변환
                if let value = response.value {
                    completion(JSON(value))
                }
            })
    }
    
    func notice(completion:@escaping (JSON)->Void) {
        AF.request("\(API.base_url)/notice").responseJSON { (response) in
            if let value = response.value {
                completion(JSON(value))
            }
        }
    }
    
    func fetch(token: String="",completion:@escaping (JSON)->Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters = [
            "token" : (token.isEmpty) ? Token.create() : token
        ]
        
        AF.request("\(API.base_url)/fetch",method:.post,parameters:parameters,encoding:URLEncoding.httpBody,headers:headers)
            .responseJSON(completionHandler: { (response) in
                //1. JSON 변환
                if let value = response.value {
                    completion(JSON(value))
                }
            })
    }
    
    func fetch_friends(friends:[String],completion:@escaping (JSON)->Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let paramsJSON = JSON(friends)
        let paramsString = paramsJSON.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted)!
        //print(paramsString)
        let parameters = [
            "friendList": paramsString,
            "userToken" : API.currentUser.token
        ]
        
    AF.request("\(API.base_url)/fetch/friend",method:.post,parameters:parameters,encoding:URLEncoding.httpBody,headers:headers)
            .responseJSON(completionHandler: { (response) in
                //1. JSON 변환
                if let value = response.value {
                    //print(value)
                    //print(JSON(value)["status"].intValue)
                    completion(JSON(value))
                }
            })
        
        
        
    }
    
    func search(query: String="",completion:@escaping (JSON)->Void) {
        
        let parameters = [
            "query" : query
        ]
        
        AF.request("\(API.base_url)/book/search",method:.get,parameters:parameters)
            .responseJSON(completionHandler: { (response) in
                //1. JSON 변환
                if let value = response.value {
                    completion(JSON(value))
                }
            })
        
        
    }
    
    func searchInGoogle(query: String="",completion:@escaping (JSON)->Void) {
        
        let parameters = [
            "query" : query
        ]
        
        AF.request("\(API.base_url)/book/search/google",method:.get,parameters:parameters)
            .responseJSON(completionHandler: { (response) in
                //1. JSON 변환
                if let value = response.value {
                    completion(JSON(value))
                }
            })
        
        
    }
    
    func setUser(fromJSON json:JSON) {
        API.currentUser = User.transformUser(fromJSON: json["user"])
    }
    
    func setBooks(fromJSON json:JSON){
        API.currentBooks = Book.transformBooks(fromJSON: json["books"])
        //print(API.currentBooks)
    }
    
    func setContents(fromJSON json:JSON){
        API.currentContents = Content.transformContent(fromJSON: json["contents"])
        //print(API.currentContents)
    }
    
    static func getJSON() {
        
    }
}
