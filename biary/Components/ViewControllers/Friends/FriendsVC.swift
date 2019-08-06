//
//  FriendsVC.swift
//  biary
//
//  Created by 이창현 on 03/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit
import AMPopTip
import Spring
import SDStateTableView

protocol FriendsDelegate{
    func selectItem(indexPath: IndexPath)
}

extension FriendsVC: FriendsDelegate {
    
    func selectItem(indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        
        //            vc.navigationBar.titleLbl.text = API.currentShowingFriend?.user.name ?? "" + "의 서재"
        //
        vc.friendMode = true
        let navigationController = UINavigationController(rootViewController: vc)
        
        
        self.present(navigationController, animated: true) {
            
            API.user.fetch_friends(friends: [API.currentFriends[indexPath.row].facebookId]) { (json) in
                
                //print(json.debugDescription)
                if (json["status"].intValue != 200) {
                    API.currentShowingFriend = Info(user: nil, books: [], contents: [])
                    
                    vc.makeTitleTo(str: "정보가 존재하지 않습니다.".localized)
                    vc.indicator?.stop()
                } else {
                    API.currentShowingFriend = Info.make(data: json["data"][0])
                    
                    if let f = API.currentShowingFriend {
                        guard let user = f.user else {return}
                        for (num,item) in user.bookShelf.enumerated() ?? [].enumerated() {
                            if (item.books.count == 0) {
                                API.currentShowingFriend?.user?.bookShelf[num].expanded = false
                            }
                        }
                        //로딩 성공
                        vc.reloadBooks()
                        vc.makeTitleToFriend()
                        vc.indicator?.stop()
                    }
                }
                
                
            }
        }
        
        
    }
}

class FriendsVC: UIViewController {
    
    var navigationBar:NavigationBar!

    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var tableView: SDStateTableView!
    
    let titles = ["페이스북 친구들".localized]
    var expanded = [true,true]
    let headerHeight:CGFloat = 60;

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar = NavigationBar(frame: CGRect.zero, title: "친구".localized)
        
        inviteBtn.tintColor = UIColor.mainColor
        UIView.animate(withDuration: 1.0, animations: {
            self.inviteBtn.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/14.5))
        })
        if (API.currentFriends.count > 10) {
            //inviteBtn.isHidden = true
            
        }
       
        
        navigationBar.settingBtn.isHidden = true
        navigationBar.line.isHidden = false
        navigationBar.addBtn.isHidden = true
        navigationBar.searchBtn.isHidden = true
        self.view.addSubview(navigationBar)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 80)
            ])
        navigationBar.setConstraints()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor)
            ])
        
        if (Connectivity.isConnectedToInternet) {
            tableView.setState(.dataAvailable)
        } else {
            tableView.setState(.withButton(errorImage: nil, title: "인터넷 연결 없음".localized,
                                           message: "인터넷에 연결되어 있지 않으므로 나중에 시도하십시오.".localized,
                                            buttonTitle: "다시 시도하기".localized,
                                            buttonConfig: { (button) in
                                                // You can configure the button here
            },
                                            retryAction: {
                                                self.tableView.reloadData()
            }))
        }
        
    }
    let pop = CustomPopTip()
    
    override func viewDidAppear(_ animated: Bool) {
        if (API.currentBooks.count < 2) {
            
            
            pop.offset = 40
            if (UIDevice().userInterfaceIdiom == .phone) {
                if (UIScreen.main.nativeBounds.height > 1334) {
                    pop.offset += 30
                }
            }
            pop.show(text: "페이스북 친구 중 책일기를 사용하는 사람들입니다.", direction: .down , to: self.view, from: self.navigationBar.titleLbl.frame, offset: pop.offset)
            
        }
    }
    
    @IBAction func inviteBtnPressed(_ sender: UIButton) {
        
        if let url = URL(string: "https://apps.apple.com/us/app/biary-%EC%B1%85%EC%9D%BD%EA%B3%A0-%EC%B1%85%EC%9D%BC%EA%B8%B0/id1462620302?l=ko&ls=1") {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
}

extension FriendsVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if expanded[section] {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: headerHeight))
        view.backgroundColor = .white
        
        
        
        let label = UILabel(frame: CGRect(x: 17, y: 0, width: 200, height: headerHeight))
        label.text = titles[section]
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        let expandImage = UIImage(named: "refresh")!
        let button = SpringButton(frame: CGRect(x: self.view.frame.width - expandImage.size.width*0.8 - 12, y: view.frame.height/2 - expandImage.size.height*0.8/2, width: expandImage.size.width*0.8, height: expandImage.size.height*0.8))
        
        button.tintColor = UIColor.Gray
        button.setImage(expandImage, for: .normal)
        
        //button.setTitle("", for: .normal)
        //turn(button: button, to: self.expanded[section])
        
        button.addTarget(self, action: #selector(refresh(sender:)), for: .touchUpInside)
        
        button.tag = section
        
        view.addSubview(button)
        view.addSubview(label)
        
        return view
    }
    
    @objc func refresh(sender: UIButton) {
//        button.tintColor = UIColor.black
        //API.currentFriends = API.currentFriends + API.currentFriends
        tableView.reloadData()
        
//        UIView.animate(withDuration:2.0, animations: {
//            button.transform = CGAffineTransform(rotationAngle: CGFloat(360))
//        })
//        button.animation = "shake"
//        button.force = 0.5
//        button.animate()
    }
    
    func turn(button:UIButton,to: Bool) {
        
        //CGFloat(Double.pi / 2)
        
        if let temp = button.imageView {
            temp.transform = temp.transform.rotated(by: CGFloat(Double.pi / 2));
            if (to == false) {
                temp.transform = temp.transform.rotated(by: CGFloat(Double.pi));
            }
        }
    }
    
    func turn(button:UIButton,to: CGFloat) {
        
        //CGFloat(Double.pi / 2)
        if let temp = button.imageView {
            temp.transform = temp.transform.rotated(by: to);
            //음수 = 열기
            //양수 = 닫기
            let current = atan2(temp.transform.b, temp.transform.a)
            //print(current)
        }
    }
    
    @objc func handleExpandClose(button: UIButton) {
        let indexPaths = [IndexPath(row: 0, section: button.tag)]
        
        //Change
        expanded[button.tag] = !expanded[button.tag]
        
        if (expanded[button.tag]) {
            tableView.insertRows(at: indexPaths, with: .automatic)
            turn(button: button, to: CGFloat(Double.pi))
        } else {
            tableView.deleteRows(at: indexPaths, with: .automatic)
            turn(button: button, to: CGFloat(Double.pi))
        }
        
        //button.setTitle(expandedData[button.tag] ? "Close" : "Open", for: .normal)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! FriendTableCell
        cell.friendDelegate = self
        
        cell.collectionView.reloadData()
        
        //print("저는 ",indexPath.row,"번 책장입니다. \n 제가 가지고 있는 책은",cell.shelfInfo?.books.count ?? 0)
        //print("저는 ",indexPath.section,"번 책장입니다. \n 제가 가지고 있는 책은",API.currentUser.bookShelf)
        
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280+100; //150
    }
    
}



