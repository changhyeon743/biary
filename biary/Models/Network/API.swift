//
//  File.swift
//  biary
//
//  Created by 이창현 on 24/02/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import SwiftyJSON

class API {
    static var base_url = "http://13.125.252.104:9000"
    static var Auth = AuthAPI()
    static var User = UserAPI()

    //static var Board = BoardAPI()
    
    static var currentJSON:JSON! = nil
    
    static var currentUser:User! = nil
    static var currentToken:String = ""
    
    static var currentBooks:[Book] = [] {
        didSet {
            
        }
    }
    static var currentContents:[Content] = []
    static var currentFriends:[Friend] = []
    
}
