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

extension Info {
    static func make(data: JSON) -> Info {
        let json = data["data"]
        let temp = Info(user: User.transformUser(fromJSON: json["user"]),
                        books: Book.transformBook(fromJSON: json["books"]),
                        contents: Content.transformContent(fromJSON: json["contents"]))
        
        return temp;
    }
}
