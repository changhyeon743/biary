//
//  Bookshelf.swift
//  biary
//
//  Created by 이창현 on 25/02/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Bookshelf {
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
}
