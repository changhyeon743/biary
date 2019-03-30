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
    ///WelcomeVC에 없을 경우
    func getFBUserData(settingVC: SettingVC) {
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
                    
                    
                    
                    self.loginCheck(settingVC: settingVC,facebookID: facebookID)
                    
                    
                    
                }
            })
        }
    }
    
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
                    
                    
                    
                    self.loginCheck(welcomeVC: welcomeVC,facebookID: facebookID)
                    
                    
                    
                }
            })
        }
    }
    
    ///Welcome vc가 아닐 경우
    func loginCheck(settingVC:SettingVC, facebookID: String) {
        print("Login check start...")
        API.user.isLogined(facebookId: facebookID, completion: { (json) in
            print("Login check: -> ",json)
            let status = JSON(json)["status"].intValue;
            print("Login check:  status:--=> ", status)
            if (status == 200) { //이미 서버에 있는 계정일 경우
                API.currentUser.isLogined = JSON(json)["data"]["isLogined"].boolValue
                settingVC.loginIssue(isLogined: API.currentUser.isLogined, token: JSON(json)["data"]["token"].stringValue)
                
                
            }
            else {//페북아이디가 존재하지 않을 경우
                //존재 안함 -> 처음에 로그인 없이 계속 했다가 로그인 한거임
                API.currentUser.isLogined = true
            }
        })
    }
    
    func loginCheck(welcomeVC: WelcomeVC,facebookID: String) {
        print("Login check start...")
        API.user.isLogined(facebookId: facebookID, completion: { (json) in
            print("Login check: -> ",json)
            let status = JSON(json)["status"].intValue;
            print("Login check:  status:--=> ", status)
            if (status == 200) { //이미 서버에 있는 계정일 경우
                print(json)
                API.currentUser.isLogined = JSON(json)["data"]["isLogined"].boolValue
                if (API.currentUser.isLogined == false) { //찾아냈는데로그인이 안된 계정일 경우
                    print("userSetting with..",facebookID)
                    API.user.fetch(token: JSON(json)["data"]["token"].stringValue, completion: { (json) in
                        let data = json["data"]
                        API.currentContents = Content.transformContent(fromJSON: data["contents"])
                        API.currentUser = User.transformUser(fromJSON: data["user"])
                        API.currentBooks = Book.transformBook(fromJSON:data["books"])
                        welcomeVC.move()
                    })
                } else { //이미 로그인 된 계정일 경우
                    welcomeVC.alreadyLogined(token: JSON(json)["data"]["token"].stringValue)
                }
                
            }
            else {//페북아이디가 존재하지 않을 경우
                API.user.register(name: API.currentUser.name, facebookId: API.currentUser.facebookId, profileURL: API.currentUser.profileURL, token: API.currentUser.token) { (json) in
                    print(json)
                }
                welcomeVC.move()
            }
        })
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
