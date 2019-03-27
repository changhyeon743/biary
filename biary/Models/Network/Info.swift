//
//  Info.swift
//  biary
//
//  Created by 이창현 on 14/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Info {
    var user:User! = nil
    
    var books:[Book] = []
    var contents:[Content] = []
}
//친구 정보 불러올 때
extension Info {
    static func make(data: JSON) -> Info {
        let json = data["data"]
        var temp = Info(user: User.transformUser(fromJSON: json["user"]),
                        books: Book.transformBook(fromJSON: json["books"]),
                        contents: Content.transformContent(fromJSON: json["contents"]))
        
//        print(privates)
//        for i in privates {
//            print(i)
//            temp.user.bookShelf = Bookshelf.clean(from: temp.user.bookShelf, bookToken: i.token)
//        }
//        print(temp.user.bookShelf)
        return temp;
    }
}
