//
//  FriendsVC.swift
//  biary
//
//  Created by 이창현 on 03/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit

class FriendsVC: UIViewController {
    
    var navigationBar:NavigationBar!

    @IBOutlet weak var tableView: UITableView!
    
    let titles = ["친구들","공개적인"]
    var expanded = [true,true]
    let headerHeight:CGFloat = 60;

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar = NavigationBar(frame: CGRect.zero, title: "탐험")
        
       
        
        navigationBar.settingBtn.isHidden = true
        navigationBar.line.isHidden = false
        navigationBar.addBtn.isHidden = true
        navigationBar.searchBtn.isHidden = true
        navigationBar.setConstraints()
        self.view.addSubview(navigationBar)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 80),
            
            tableView.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        
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
        
        let expandImage = UIImage(named: "arrow_back")!
        let button = UIButton(frame: CGRect(x: self.view.frame.width - expandImage.size.width - 12, y: view.frame.height/2 - expandImage.size.height/2, width: expandImage.size.width, height: expandImage.size.height))
        button.tintColor = UIColor.Gray
        button.setImage(expandImage, for: .normal)
        
        //button.setTitle("", for: .normal)
        turn(button: button, to: self.expanded[section])
        
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
        cell.friendVC = self
        
        cell.collectionView.reloadData()
        
        //print("저는 ",indexPath.row,"번 책장입니다. \n 제가 가지고 있는 책은",cell.shelfInfo?.books.count ?? 0)
        //print("저는 ",indexPath.section,"번 책장입니다. \n 제가 가지고 있는 책은",API.currentUser.bookShelf)
        
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280; //150
    }
    
}



