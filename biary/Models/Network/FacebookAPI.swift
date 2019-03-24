//
//  Facebook.swift
//  biary
//
//  Created by 이창현 on 18/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON

class FacebookAPI {
    
    
    func getFBUserData(welcomeVC: WelcomeVC) {
        if((FBSDKAccessToken.current()) != nil){
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id,name,picture"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    print(result)
                    //everything works print the user data
                    let data = JSON(result)
                    
                    
                    
                    let name = data["name"].stringValue
                    let facebookID = data["id"].stringValue
                    let profile = data["picture"]["data"]["url"].stringValue
                    
                    API.currentUser.name = name;
                    API.currentUser.facebookId = facebookID;
                    API.currentUser.profileURL = profile;
                    
                    API.user.isLogined(facebookId: facebookID, completion: { (json) in
                        API.currentUser.isLogined = JSON(json)["data"].boolValue
                        print("is Logined = ",API.currentUser.isLogined)
                        welcomeVC.move()
                    })
                    
                }
            })
        }
    }
    
    func getFBfriendData(){
        if((FBSDKAccessToken.current()) != nil){
            
            FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields": "id,name,picture"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    API.currentFriends = Friend.transform(fromJSON: JSON(result)["data"])
                    print(API.currentFriends)
                }
            })
        }
    }
    
    func isAlreadyLogined() -> Bool {
            return API.currentUser.isLogined
    }
}
