//
//  WelcomeVC.swift
//  biary
//
//  Created by 이창현 on 25/02/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SwiftyJSON


class WelcomeVC: UIViewController {

    @IBOutlet weak var facebookBtn: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(loginBtnPressed(_:)))
        facebookBtn.addGestureRecognizer(gesture)
        
        API.User.fetch(token: "changhyeontoken123") { (temp) in
            let json = temp["data"]
            //print(json)
            API.User.setUser(fromJSON: json)
            API.User.setBooks(fromJSON: json)
            API.User.setContents(fromJSON: json)
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func loginBtnPressed(_ sender: Any) {
        if ( FBSDKAccessToken.current() == nil ) {
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.logIn(withReadPermissions: ["public_profile","email","user_friends"], from: self) { (result, error) -> Void in
                if (error == nil){
                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
                    // if user cancel the login
                    if (result?.isCancelled)!{
                        return
                    }
                    if(fbloginresult.grantedPermissions.contains("user_friends"))
                    {
                        self.getFBUserData()
                    }
                    
                    self.gotoMain()
                }
            }
        } else {
            self.getFBUserData()
            self.gotoMain()
        }
        
        
    }
    
    func getFBUserData(){
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
    
    @IBAction func nonLoginPressed(_ sender: Any) {
        
        gotoMain()
        //vc.dismiss(animated: true, completion: nil)

    }
    
    func gotoMain() {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc  = storyboard.instantiateInitialViewController() as! UITabBarController
        //        let ad = UIApplication.shared.delegate as! AppDelegate
        //        ad.setRootVC(to: vc)
        self.view.window?.rootViewController = vc
        self.present(vc, animated: true, completion: nil)
    }
    
}
