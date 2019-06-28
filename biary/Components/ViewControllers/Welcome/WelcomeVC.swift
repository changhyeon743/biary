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
                        API.facebook.getFBUserData(welcomeVC: self)
                    }
                   
                }
            }
        } else {
            API.facebook.getFBfriendData()
            self.gotoMain()
        }
        
        
    }
    
    func alreadyLogined(token: String) { //이미 로그인된 계정일 경우
        print("token:" ,token)
        let alert = UIAlertController(title: "이미 다른 기기에 로그인된 계정입니다.", message: "기기들 중 하나의 기기의 데이터만 서버에 올라갑니다.\n 주의해주세요. ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "불러오기", style: .default, handler: { (_) in
            API.user.fetch(token: token, completion: { (json) in
                let data = json["data"]
                API.currentContents = Content.transformContent(fromJSON: data["contents"])
                API.currentUser = User.transformUser(fromJSON: data["user"])
                API.currentBooks = Book.transformBook(fromJSON:data["books"])
                self.gotoMain()
            })
        }))
        alert.addAction(UIAlertAction(title: "새로 시작하기", style: .default, handler: { (_) in
            
            API.user.fetch(token: token, completion: { (json) in
                let data = json["data"]
                API.currentContents = []
                API.currentUser = User.transformUser(fromJSON: data["user"])
                API.currentBooks = []
                API.currentUser.bookShelf = [Bookshelf(title: "읽고 있는 책", books: [], expanded: true)]
                self.gotoMain()
            })
        }))
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (_) in
            LoginManager().logOut()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func move() {
        //print("move Action..", API.currentUser)
        if (API.currentUser.isLogined) {
            let alert = UIAlertController(title: "오류", message: "다른 기기에서 사용중인 아이디입니다.\n 계속하려면 기존의 기기 설정에서 로그아웃 해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            LoginManager().logOut()
        } else {
            //로그인이 안되있었을경우 (정상적)
            API.currentUser.isLogined = true
            API.user.update { (json) in
                //print(json)
            }
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
    @IBAction func personalInfoBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "개인정보처리방침", message:
"""
1. 개인정보의 처리 목적 <리마크프레스>(‘https://remarkpress.kr/’이하 ‘리마크프레스’) 은(는) 다음의 목적을 위하여 개인정보를 처리하고 있으며, 다음의 목적 이외의 용도로는 이용하지 않습니다. - 고객 가입의사 확인, 고객에 대한 서비스 제공에 따른 본인 식별.인증, 회원자격 유지.관리, 물품 또는 서비스 공급에 따른 금액 결제, 물품 또는 서비스의 공급.배송 등   2. 개인정보의 처리 및 보유 기간  ① <리마크프레스>(‘https://remarkpress.kr/’이하 ‘리마크프레스’) 은(는) 정보주체로부터 개인정보를 수집할 때 동의 받은 개인정보 보유․이용기간 또는 법령에 따른 개인정보 보유․이용기간 내에서 개인정보를 처리․보유합니다.  ② 구체적인 개인정보 처리 및 보유 기간은 다음과 같습니다. ☞ 아래 예시를 참고하여 개인정보 처리업무와 개인정보 처리업무에 대한 보유기간 및 관련 법령, 근거 등을 기재합니다. (예시)- 고객 가입 및 관리 : 서비스 이용계약 또는 회원가입 해지시까지, 다만 채권․채무관계 잔존시에는 해당 채권․채무관계 정산시까지 - 전자상거래에서의 계약․청약철회, 대금결제, 재화 등 공급기록 : 5년    
            3. 정보주체와 법정대리인의 권리·의무 및 그 행사방법 이용자는 개인정보주체로써 다음과 같은 권리를 행사할 수 있습니다.
            ① 정보주체는 리마크프레스(‘https://remarkpress.kr/’이하 ‘리마크프레스) 에 대해 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다. 1. 개인정보 열람요구 2. 오류 등이 있을 경우 정정 요구 3. 삭제요구 4. 처리정지 요구
            
            
            4. 처리하는 개인정보의 항목 작성   ① <리마크프레스>('https://remarkpress.kr/'이하 '리마크프레스')은(는) 다음의 개인정보 항목을 처리하고 있습니다.
            1<로그인> - 필수항목 : 로그인ID, 이름 - 선택항목 :
            
            
            
            5. 개인정보의 파기<리마크프레스>('리마크프레스')은(는) 원칙적으로 개인정보 처리목적이 달성된 경우에는 지체없이 해당 개인정보를 파기합니다. 파기의 절차, 기한 및 방법은 다음과 같습니다.
            -파기절차 이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서류) 내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다. 이 때, DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.  -파기기한 이용자의 개인정보는 개인정보의 보유기간이 경과된 경우에는 보유기간의 종료일로부터 5일 이내에, 개인정보의 처리 목적 달성, 해당 서비스의 폐지, 사업의 종료 등 그 개인정보가 불필요하게 되었을 때에는 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 5일 이내에 그 개인정보를 파기합니다.
            
            
            
            6. 개인정보 자동 수집 장치의 설치•운영 및 거부에 관한 사항
            리마크프레스 은 정보주체의 이용정보를 저장하고 수시로 불러오는 ‘쿠키’를 사용하지 않습니다.  
            7. 개인정보 보호책임자 작성
            
            ① 리마크프레스(‘https://remarkpress.kr/’이하 ‘리마크프레스) 은(는) 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.
             ▶ 개인정보 보호책임자  성명 :이재준 직책 :대표이사 직급 :대표 연락처 :02-365-6371, remarkpress@naver.c om, 02-365-6372 ※ 개인정보 보호 담당부서로 연결됩니다.  ▶ 개인정보 보호 담당부서 부서명 : 담당자 : 연락처 :, ,  ② 정보주체께서는 리마크프레스(‘https://remarkpress.kr/’이하 ‘리마크프레스) 의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. 리마크프레스(‘https://remarkpress.kr/’이하 ‘리마크프레스) 은(는) 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.
            
            
            8. 개인정보 처리방침 변경
            ①이 개인정보처리방침은 시행일로부터 적용되며, 법령 및 방침에 따른 변경내용의 추가, 삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 공지사항을 통하여 고지할 것입니다.
            
            
            9. 개인정보의 안전성 확보 조치 <리마크프레스>('리마크프레스')은(는) 개인정보보호법 제29조에 따라 다음과 같이 안전성 확보에 필요한 기술적/관리적 및 물리적 조치를 하고 있습니다.
            1. 개인정보 취급 직원의 최소화 및 교육 개인정보를 취급하는 직원을 지정하고 담당자에 한정시켜 최소화 하여 개인정보를 관리하는 대책을 시행하고 있습니다.  2. 비인가자에 대한 출입 통제 개인정보를 보관하고 있는 물리적 보관 장소를 별도로 두고 이에 대해 출입통제 절차를 수립, 운영하고 있습니다.  
"""
            , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)

    }
    
}
