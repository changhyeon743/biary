//
//  Friend.swift
//  biary
//
//  Created by 이창현 on 10/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Friend {
    var name: String
    var facebookId: String
    var profileURL: String
}

extension Friend {
    static func transform(fromJSON temp:JSON) -> [Friend] {
        let json = temp.arrayValue
        
        let user = json.map{Friend(name: $0["name"].stringValue,
                                   facebookId: $0["id"].stringValue,
                                   profileURL: $0["picture"]["data"]["url"].stringValue)}
        
        //print(user)
        return user
    }
}
