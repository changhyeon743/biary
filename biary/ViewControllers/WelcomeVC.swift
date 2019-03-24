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
        
        //첫유저가 들어와서 로그인 없이 계속을 누르면 initialize가 나오겎지? 그럼 loadall에서 새로운 계정일 경우에서만
        //서버에 add 전송하면 되겠지
        
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
                        API.facebook.getFBfriendData()
                    }
                    if(fbloginresult.grantedPermissions.contains("public_profile")) {
                        API.facebook.getFBUserData(welcomeVC: self)
                    }
                   
                    
                    
                    
                }
            }
        } else {
            API.facebook.getFBfriendData()
            self.gotoMain()
        }
        
        
    }
    
    func move() {
        print("move Action..", API.currentUser.isLogined)
        if (API.currentUser.isLogined) {
            let alert = UIAlertController(title: "오류", message: "다른 기기에서 사용중인 아이디입니다.\n 계속하려면 기존의 기기 설정에서 로그아웃 해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            FBSDKLoginManager().logOut()
        } else {
            //로그인이 안되있었을경우 (정상적)
            API.currentUser.isLogined = true
            self.gotoMain()
        }
    }
    
    @IBAction func nonLoginPressed(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc  = storyboard.instantiateInitialViewController() as! UITabBarController
        //        let ad = UIApplication.shared.delegate as! AppDelegate
        //        ad.setRootVC(to: vc)
        self.view.window?.rootViewController = vc
        self.present(vc, animated: true, completion: nil)
        //gotoMain()
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
