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
    static var auth = AuthAPI()
    static var user = UserAPI()
    static var facebook = FacebookAPI()
    static var data = Datas()

    //static var Board = BoardAPI()
    
    static var currentJSON:JSON! = nil
    
    static var currentUser:User! = nil {
        didSet {
            API.data.saveUser()
            API.user.update()
        }
    }
    static var currentToken:String = ""
    
    static var currentBooks:[Book] = [] {
        didSet {
            API.data.saveBooks()
            //API.user.update()
        }
    }
    static var currentContents:[Content] = [] {
        didSet {
            API.data.saveContents()
            //API.user.update()
        }
    }
    static var currentFriends:[Friend] = []
    
    static var currentShowingFriend:Info? = nil
    
    static var currentColor:UIColor = UIColor(r: 255, g: 255, b: 255)
}
