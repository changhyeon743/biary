//
//  Bookshelf.swift
//  biary
//
//  Created by 이창현 on 25/02/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Bookshelf:Codable {
    var title: String
    var books: [String]
    var expanded: Bool
}

extension Bookshelf {
    static func transformBookshelf(fromJSON temp:JSON) -> Bookshelf {
        let json = temp
        let bookshelf = Bookshelf(title: json["title"].stringValue,
                                  books: json["books"].arrayValue.map{$0.stringValue},
                                  expanded: true)
        //print(bookshelf)
        
        return bookshelf
    }
    
    
    
    static func append(title:String) {
        let bookshelf = Bookshelf(title: title, books: [], expanded: true)
        API.currentUser.bookShelf.append(bookshelf);
    }
    
    static func clean(bookToken: String) {
        for (l,e) in API.currentUser.bookShelf.enumerated() {
            for (i,element) in e.books.enumerated() {
                if (element == bookToken) {
                    API.currentUser.bookShelf[l].books.remove(at: i)
                }
            }
        }
    }
    
    static func clean(from: [Bookshelf], bookToken: String) -> [Bookshelf] {
        var bookshelf = from;
        for (l,e) in from.enumerated() {
            for (i,element) in e.books.enumerated() {
                if (element == bookToken) {
                    bookshelf[l].books.remove(at: i)
                }
            }
        }
        return bookshelf
    }
    
    static func getCount(bookToken: String) -> Int{
        
        var count = 0;
        for i in API.currentUser.bookShelf {
            count += i.books.filter{$0 == bookToken}.count
        }
        return count;
    }
    
    
    static func addBook(at bookshelfs: [Bookshelf], bookToken: String) {
        for i in bookshelfs {
            for (index,l) in API.currentUser.bookShelf.enumerated() {
                if (l.title == i.title) {
                    API.currentUser.bookShelf[index].books.insert(bookToken, at:0)
                }
            }
        }
    }
}
