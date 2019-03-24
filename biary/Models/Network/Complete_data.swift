//
//  complete_data.swift
//  biary
//
//  Created by 이창현 on 18/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation

struct Complete_data: Codable {
    var user: User
    var books: [Book]
    var contents: [Content]
}


extension Complete_data {
    static func make() -> Complete_data {
        let data = Complete_data(user: API.currentUser, books: API.currentBooks, contents: API.currentContents)
        return data
    }
}
