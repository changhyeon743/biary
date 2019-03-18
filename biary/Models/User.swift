//
//  User.swift
//  biary
//
//  Created by 이창현 on 25/02/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import SwiftyJSON
import FBSDKCoreKit
/*
 "user": {
 "_id": "5c3c3806e64a560e43b651e6",
 "name": "삼창현",
 "facebookId": "id2",
 "profileURL": "url",
 "token": "threechanghyeon",
 "bookShelf": [
 {
 "books": [
 "token3",
 "token4"
 ],
 "_id": "5c3c3855e2b4700e5c0f6f24",
 "title": "소설"
 },
 {
 "books": [
 "token4"
 ],
 "_id": "5c3c3855e2b4700e5c0f6f23",
 "title": "거꾸로 책"
 }
 ],
 "__v": 0
 }
 
 */
struct User: Codable {
    var name: String
    var facebookId: String
    var profileURL: String
    var token: String
    var bookShelf: [Bookshelf]
}

extension User {
    static func transformUser(fromJSON temp:JSON) -> User? {
        let json = temp
        
        let user = User(name: json["name"].stringValue,
                        facebookId: json["facebookId"].stringValue,
                        profileURL: json["profileURL"].stringValue,
                        token: json["token"].stringValue,
                        bookShelf: json["bookShelf"].arrayValue.map{Bookshelf.transformBookshelf(fromJSON: $0)})
        
        //print(user)
        return user
    }
    
    static func makeInitialUser(withName name:String, profile: String) -> User{
        let facebookid = FBSDKAccessToken.current()?.userID ?? "null"
        let user = User(name: name, facebookId: facebookid, profileURL: profile, token: Token.create(), bookShelf: [])
        
        return user;
    }
    
    static func makeInitialUser() -> User{
        let user = User(name: "이름 없음", facebookId: "null", profileURL: "", token: Token.create(), bookShelf: [])
        
        return user;
    }
}


