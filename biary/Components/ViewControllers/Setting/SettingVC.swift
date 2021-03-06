//
//  SettingVC.swift
//  biary
//
//  Created by 이창현 on 29/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit
import Carte
import FBSDKCoreKit
import FBSDKLoginKit


class SettingVC: UIViewController {
    var navigationBar: NavigationBar!
    
    @IBOutlet weak var login: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        setLoginBtn()
    }
    
    func setLoginBtn() {
        if (API.currentUser.isLogined == true) {
            login.setTitle("로그아웃".localized, for: .normal)
        } else{
            login.setTitle("로그인".localized, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar = NavigationBar(frame: CGRect.zero, title: "설정".localized)
        if title != nil {
            navigationBar.titleLbl.text = title!
        }
        
        navigationBar.settingBtnHandler = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "bookshelf") as! BookShelfVC
            self.present(vc, animated: true, completion: nil)
            //self.performSegue(withIdentifier: "bookshelfSegue", sender: nil)
        }
        navigationBar.closeBtnHandler = {
            self.dismiss(animated: true, completion: nil)
        }
        
        
        self.view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 130)
            ])
        navigationBar.setConstraints()
        navigationBar.setToAnotherNavigation(sub: "")
        
    }
    

    
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch sender.titleLabel?.text ?? "" {
        case "공지사항/이벤트".localized:
            notice()
            print(API.currentUser)
            break;
        case "문의하기".localized:
            let email = "changhyeon743@gmail.com"
            if let url = URL(string: "mailto:\(email)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            break;
        case "페이스북 페이지".localized:
            UIApplication.shared.open(URL(string: "http://facebook.com/biaryapp")!, options: [:], completionHandler: nil)
            break;
        case "리뷰 남기기".localized:
            let id = "1462620302"
            guard let url = URL(string : "itms-apps://itunes.apple.com/app/id\(id)?mt=8&action=write-review") else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }

            break;
        case "라이센스".localized:
            let vc = CarteViewController()
            let navigationController = UINavigationController(rootViewController: vc)
            
        self.present(navigationController, animated: true, completion: nil)
            break;
        case "이름 변경".localized:
            let alert = UIAlertController(title: "이름 변경".localized, message: nil, preferredStyle: .alert)
            let backAction = UIAlertAction(title: "취소".localized, style: .default)
            let okAction = UIAlertAction(title: "확인".localized, style: .default) { (alertAction) in
                let textField = alert.textFields![0] as UITextField
                
                API.currentUser.name = textField.text!
            }
            
            alert.addTextField { (textField) in
                textField.text = API.currentUser.name
            }
            
            alert.addAction(backAction)
            alert.addAction(okAction)
            
            self.present(alert, animated:true, completion: nil)
            break;
        case "초기화".localized:
            let alert = UIAlertController(title: "초기화".localized, message: "모든 책과 글이 사라집니다. ".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "초기화".localized, style: .destructive, handler: { (_) in
                API.currentBooks = []
                API.currentContents = []
                API.currentUser.bookShelf = []
                
                //API.data.removeAll()
                
                
                LoginManager().logOut()
                
                let vc = UIStoryboard(name: "Welcome", bundle: nil).instantiateInitialViewController() as! WelcomeVC
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "취소".localized, style: .cancel, handler: { (_) in
                LoginManager().logOut()
            }))
            
            self.present(alert, animated: true, completion: nil)
            break;
        case "로그아웃".localized:
            let alert = UIAlertController(title: "정말 로그아웃 하시겠습니까?".localized, message: "데이터가 서버에 올라가지 않습니다.".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "취소".localized, style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "로그아웃".localized, style: .destructive, handler: { (_) in
                API.currentUser.isLogined = false
                API.user.logoutUpdate()
                LoginManager().logOut()
                
                self.setLoginBtn()
            }))
            
            self.present(alert, animated: true, completion: nil)
            break;
        case "로그인".localized:
            loginBtnPressed()
            break;
        default:
            break;
        }
        //print(sender.titleLabel?.text ?? "")
    }
    
    func notice() {
        API.user.notice { (json) in
            let temp = json["data"]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let notices = temp.arrayValue.map{Notice(title: $0["title"].stringValue,article: $0["article"].stringValue,date: dateFormatter.date(from: $0["date"].stringValue) ?? Date())}
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoticeVC") as! NoticeVC
            vc.notices = notices
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func loginBtnPressed() {
        if ( AccessToken.current == nil ) {
            let fbLoginManager : LoginManager = LoginManager()
            fbLoginManager.logIn(permissions: ["public_profile","email","user_friends"], from: self) { (result, error) -> Void in
                if (error == nil){
                    let fbloginresult : LoginManagerLoginResult = result!
                    // if user cancel the login
                    if (result?.isCancelled)!{
                        return
                    }
                    if(fbloginresult.grantedPermissions.contains("user_friends"))
                    {
                        API.facebook.getFBfriendData()
                    }
                    if(fbloginresult.grantedPermissions.contains("public_profile")) {
                        API.facebook.getFBUserData(settingVC: self)
                    }
                    
                }
            }
        } else {
            API.currentUser.isLogined = true
        }
        
    }
    
    func loginIssue(isLogined: Bool, token: String) { //서버에 이미 데이터가 있습니다.
        let alert = UIAlertController(title: "데이터 충돌".localized, message: "서버에 이미 데이터가 있습니다.".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "기존 데이터 유지".localized, style: .default, handler: { (_) in
            
        }))
        
        alert.addAction(UIAlertAction(title: "서버 데이터 불러오기".localized, style: .cancel, handler: { (_) in
            
            if (isLogined == false) { //찾아냈는데로그인이 안된 계정일 경우
                //print("fetching",token)
                API.user.fetch(token: token, completion: { (json) in
                    let data = json["data"]
                    API.currentContents = Content.transformContent(fromJSON: data["contents"])
                    API.currentUser = User.transformUser(fromJSON: data["user"])
                    API.currentBooks = Book.transformBooks(fromJSON:data["books"])
                })
                
            } else { //이미 로그인 된 계정일 경우
                let alert = UIAlertController(title: "이미 다른 기기에 로그인된 계정입니다.".localized, message: "기기들 중 하나의 기기의 데이터만 서버에 올라갑니다.\n 주의해주세요. ".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "불러오기".localized, style: .default, handler: { (_) in
                    API.user.fetch(token: token, completion: { (json) in
                        let data = json["data"]
                        API.currentContents = Content.transformContent(fromJSON: data["contents"])
                        API.currentUser = User.transformUser(fromJSON: data["user"])
                        API.currentBooks = Book.transformBooks(fromJSON:data["books"])
                    })
                }))
                
                alert.addAction(UIAlertAction(title: "취소".localized, style: .cancel, handler: { (_) in
                    LoginManager().logOut()
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        self.loginEnded()
    }
    
    func loginEnded() {
        API.currentUser.isLogined = true
        self.setLoginBtn()
    }
}
