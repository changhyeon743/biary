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
        print("friend INFO:: -> \n",json)
        var temp = Info(user: User.transformUser(fromJSON: json["user"]),
                        books: Book.transformBook(fromJSON: json["books"]),
                        contents: Content.transformContent(fromJSON: json["contents"]))
        
        let publicbooks = temp.books.filter{$0.isPublic ?? true}
        let privatebooks = temp.books.filter{!($0.isPublic ?? true)}
        for i in privatebooks {
            temp.user.bookShelf = Bookshelf.clean(from: temp.user.bookShelf, bookToken: i.token)
        } 
        //jj0RTnPhbMtiWBp 가. 없어야함.
//        print(privates)
//        for i in privates {
//            print(i)
//            temp.user.bookShelf = Bookshelf.clean(from: temp.user.bookShelf, bookToken: i.token)
//        }
//        print(temp.user.bookShelf)
        return temp;
    }
}
