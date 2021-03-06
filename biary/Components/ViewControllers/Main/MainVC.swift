//
//  MainVC.swift
//  biary
//
//  Created by 이창현 on 26/10/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit
import Alamofire
import Disk
import SwiftyJSON
import FBSDKLoginKit
import AMPopTip
import SDStateTableView
protocol MainVCDelegate {
    func refresh()
}
class MainVC: UIViewController, MainVCDelegate {
    func refresh() {
        reloadBooks()
    }
    
    @IBOutlet weak var tableView:SDStateTableView!
    
    let headerHeight:CGFloat = 60;
    //var expanded = [true,true,true]
    var bookshelfs: [Bookshelf] {
        get {
            if (friendMode) {
                return API.currentShowingFriend?.user?.bookShelf ?? []
            } else {
                return API.currentUser?.bookShelf ?? []
            }
            
        }
    }
    var navigationBar:NavigationBar!
    
    var friendMode = false;
    
    var indicator: IndicatorView?
    
    override func viewDidAppear(_ animated: Bool) {
        reloadBooks()
        //tabBarController?.tabBar.isTranslucent = false;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "purchased")
        
        
        indicator = IndicatorView(uiView: self.view)
        self.view.setBackGroundColorToSystem()
        tableView.setBackGroundColorToSystem()
        navigationController?.navigationBar.isHidden = true
        
        navigationBar = NavigationBar(frame: CGRect.zero, title: "나의 서재".localized)
        
        
        
        navigationBar.searchBtn.isHidden = true
        navigationBar.line.isHidden = false
        
        navigationBar.settingBtnHandler = {
            let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            action.popoverPresentationController?.sourceView = self.navigationBar.settingBtn

            action.addAction(UIAlertAction(title: "책장 설정".localized, style: .default, handler: { _ in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "bookshelf") as! BookShelfVC
                vc.mainVCDelegate = self
                self.present(vc, animated: true, completion: nil)
            }))
            action.addAction(UIAlertAction(title: "전체 설정".localized, style: .default, handler: { _ in
                //                print(API.currentBooks.count)
                //                do {try Disk.clear(.documents)} catch {}
                //                FBSDKLoginManager().logOut()
                //
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
                self.present(vc, animated: true, completion: nil)
            }))
            action.addAction(UIAlertAction(title: "취소".localized, style: .cancel, handler: nil))
            
            self.present(action, animated: true, completion: nil)
            
            //self.performSegue(withIdentifier: "bookshelfSegue", sender: nil)
        }
        
       
        
        navigationBar.addBtnHandler = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookAddSearchVC") as! BookAddSearchVC
            vc.mainVC = self
            self.present(vc, animated: true, completion: nil)
        }
        self.view.addSubview(navigationBar)
        
        
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
        
        
        if (friendMode == true) {
            makeToFriendMode()
        } else if (API.currentBooks.count < 2) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.pop.shouldDismissOnTap = true
                self.pop.bubbleColor = UIColor.mainColor
                self.pop.padding = 10
                self.pop.offset = 20
                if (UIDevice().userInterfaceIdiom == .phone) {
                    if (UIScreen.main.nativeBounds.height > 1334) {
                        self.pop.offset += 30
                    }
                }
                
                self.pop.show(text: "눌러서 책을 추가하세요".localized, direction: .down, maxWidth: 200, in: self.view, from: self.navigationBar.addBtn.frame)
            }
        }
        
        
    }
    let pop = PopTip()
    
    func makeTitleToFriend() {
        self.navigationBar.titleLbl.text = API.currentShowingFriend?.user?.name ?? ""
    }
    func makeTitleTo(str:String) {
        self.navigationBar.titleLbl.text = str
    }
    
    func makeToFriendMode() {
        makeTitleTo(str: "불러오는 중입니다".localized)
        

        indicator?.start()
        self.navigationBar.settingBtnHandler = {
            API.currentShowingFriend = nil
            self.dismiss(animated: true, completion: nil)
        }
        

        self.navigationBar.searchBtn.isHidden = true
        self.navigationBar.addBtn.isHidden = true
        self.navigationBar.settingBtn.setImage(UIImage(named:"close"), for: .normal)
        

        //print("makeToFriendMode : ",bookshelfs)
        
    }
    
    
    func reloadBooks() {
        //self.expanded = Array(repeating: true, count: API.currentUser.bookShelf.count)
        if (friendMode) {
            if (API.currentShowingFriend?.books.count == 0) {
                tableView.setState(.withImage(image: nil, title: "비어있는 서재입니다.", message: ""))
            }
        } else if (API.currentBooks.count == 0) {
            tableView.setState(.withImage(image: nil, title: "비어있는 서재입니다.", message: ""))
        } else {
            tableView.setState(.dataAvailable)
        }
        
        
        self.tableView.reloadData()
        
    }
    
    func gotoDetail(withBook book:Book) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookDetailVC") as! BookDetailVC
        vc.bookInfo = book
        //print(API.currentContents,"중\n",vc.contents)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        reloadBooks()
    }
}


extension MainVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if bookshelfs[section].expanded {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == bookshelfs.count-1) {
            return 50
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return bookshelfs.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: headerHeight))
        view.setBackGroundColorToSystem()
        
        
        
        let label = UILabel(frame: CGRect(x: 17, y: 0, width: 200, height: headerHeight))
        label.text = (friendMode) ? API.currentShowingFriend?.user?.bookShelf[section].title ?? "" :  API.currentUser.bookShelf[section].title
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        let expandImage = UIImage(named: "arrow_back")!
        let button = UIButton(frame: CGRect(x: self.view.frame.width - expandImage.size.width - 12, y: view.frame.height/2 - expandImage.size.height/2, width: expandImage.size.width, height: expandImage.size.height))
        button.tintColor = UIColor.Gray
        button.setImage(expandImage, for: .normal)
        
        //button.setTitle("", for: .normal)
        turn(button: button, to: self.bookshelfs[section].expanded)
        
        
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        
        button.tag = section
        
        
        
        view.addSubview(button)
        view.addSubview(label)
        
        return view
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
        if (friendMode) {
            let a = !(API.currentShowingFriend?.user?.bookShelf[button.tag].expanded ?? true)
            API.currentShowingFriend?.user?.bookShelf[button.tag].expanded = a
//            API.currentShowingFriend?.user.bookShelf[button.tag].expanded = !bookshelfs[button.tag].expanded
        } else {
            API.currentUser.bookShelf[button.tag].expanded = !bookshelfs[button.tag].expanded
        }
//
//
        if (bookshelfs[button.tag].expanded) {
            tableView.insertRows(at: indexPaths, with: .automatic)
            turn(button: button, to: CGFloat(Double.pi))
        } else {
            tableView.deleteRows(at: indexPaths, with: .automatic)
            turn(button: button, to: CGFloat(Double.pi))
        }
        
        //button.setTitle(expandedData[button.tag] ? "Close" : "Open", for: .normal)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! MainTableCell
        cell.mainViewController = self
        
        if (friendMode) {
            if let info = API.currentShowingFriend, let user = API.currentShowingFriend?.user {
                if (user.bookShelf.count > 0) {
                    cell.shelfInfo = user.bookShelf[indexPath.section]
                    cell.shelfIndex = indexPath.section
                    
                    cell.bookInfo = (cell.shelfInfo?.books.map{info.books[Book.find(withToken: $0,at: info.books)]}) ?? []
                    
                }
            }
        } else {
            if (API.currentUser.bookShelf.count > 0) {
                cell.shelfInfo = API.currentUser.bookShelf[indexPath.section]
                cell.shelfIndex = indexPath.section
                if (API.currentBooks.count > 0) {
                    cell.bookInfo = (cell.shelfInfo?.books.map{API.currentBooks[Book.find(withToken: $0)]}) ?? []
                }
                
                
            }
        }
        
        cell.collectionView.reloadData()
       
        //print("저는 ",indexPath.row,"번 책장입니다. \n 제가 가지고 있는 책은",cell.shelfInfo?.books.count ?? 0)
        //print("저는 ",indexPath.section,"번 책장입니다. \n 제가 가지고 있는 책은",API.currentUser.bookShelf)

        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140; //150
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BookTableCell
//
//        return cell.collectionView.collectionViewLayout.collectionViewContentSize.height+cell.titleLabel.frame.height+24+12+12
//    }
    
}
