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
struct Content {
    var title: String
    var article: String
    var bookToken: String
    var date: Date
}

extension Content {
    static func transformContent(fromJSON temp:JSON) -> [Content] {
        let json = temp.arrayValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let contents = json.map{Content(title: $0["title"].stringValue,
                                        article: $0["article"].stringValue,
                                        bookToken: $0["bookToken"].stringValue,
                                        date: dateFormatter.date(from: $0["date"].stringValue) ?? Date())}
        print(contents)
        
        return contents
    }
}


