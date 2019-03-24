//
//  Content.swift
//  biary
//
//  Created by 이창현 on 25/02/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import SwiftyJSON


/*
{ "_id" : ObjectId("5c3a3def713d0f6e3d7fdba6"), "title" : "최고의 문장", "article" : "시험은 사람을 판단하지 못해.", "bookToken" : "token2", "date" : ISODate("2018-01-01T00:00:00Z"), "__v" : 0 }
 */
struct Content: Codable {
    var title: String
    var article: String
    var bookToken: String
    var date: Date
    var token: String
}

extension Content {
    static func transformContent(fromJSON temp:JSON) -> [Content] {
        let json = temp.arrayValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let firstDate = json[0]["date"].stringValue;
        
        print(firstDate,"\n","thisis : ", dateFormatter.date(from: firstDate))
        
        let contents = json.map{Content(title: $0["title"].stringValue,
                                        article: $0["article"].stringValue,
                                        bookToken: $0["bookToken"].stringValue,
                                        date: dateFormatter.date(from: $0["date"].stringValue)!,
                                        token: $0["token"].stringValue)}
        
        return contents
    }
    
    static func append(title:String,article: String,token: String) {
        let content = Content(title: title, article: article, bookToken: token, date: Date(), token: Token.create())
        print("appended")
        API.currentContents.append(content);
    }
    
    static func edit(title:String,article: String,bookToken: String, contentToken: String) {
        let content = Content(title: title, article: article, bookToken: bookToken, date: Date(), token: contentToken)
        
        API.currentContents[Content.find(withToken: contentToken)] = content
    }
    
    static func find(withToken token:String) -> Int{
        if (API.currentContents.count != 0) {
            let index = API.currentContents.firstIndex(where: { (content) -> Bool in
                return content.token == token
            }) ?? 0;
            return index
        } else {
            return 0
        }
    }
}


