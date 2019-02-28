
//
//  Book.swift
//  biary
//
//  Created by 이창현 on 25/02/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import SwiftyJSON

/*
 "title": "나미야 잡화점의 기적",
 "author": "히가시노 게이고",
 "publisher": "현대문학",
 "isbn": "8972756199 9788972756194",
 "imageURL": "https://bookthumb-phinf.pstatic.net/cover/071/027/07102772.jpg?type=m1&udate=20181226",
 "writerToken": "threechanghyeon",
 "token": "token3",
 "description": "나미야 잡화점의 기적입니다.",
 "date": "2018-01-01T00:00:00.000Z",
 
 */
struct Book {
    var title: String
    var author: String
    var publisher: String
    var isbn: String
    var imageURL: String
    var writerToken: String
    var token: String
    var description: String
    var date: Date
}

extension Book {
    static func transformBook(fromJSON temp:JSON) -> [Book] {
        let json = temp.arrayValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let books = json.map{Book(title: $0["title"].stringValue,
                                  author: $0["author"].stringValue,
                                  publisher: $0["publisher"].stringValue,
                                  isbn: $0["isbn"].stringValue,
                                  imageURL: $0["imageURL"].stringValue,
                                  writerToken: $0["writerToken"].stringValue,
                                  token: $0["token"].stringValue,
                                  description: $0["description"].stringValue,
                                  date: dateFormatter.date(from: $0["date"].stringValue) ?? Date())}
        
        print(books)
        
        return books
    }
    
    static func findBook(withToken token:String) -> Book{
        if (API.currentBooks.count != 0) {
            let index = API.currentBooks.firstIndex(where: { (book) -> Bool in
                return book.token == token
            }) ?? 0;
            return API.currentBooks[index]
        } else {
            return API.currentBooks[0]
        }
    }
    
    
}


