//
//  BookShelfSelectingVC.swift
//  biary
//
//  Created by 이창현 on 04/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit

class BookShelfSelectingVC: UIViewController {
    var navigationBar:NavigationBar!

    @IBOutlet weak var tableView: UITableView!
    
    var doneBtn: UIButton!
    
    var checked = [Bool]()
    
    var bookCreateVC: BookCreateVC?
    
    override func viewDidLoad() {
        
        checked = Array(repeating: false, count: API.currentUser.bookShelf.count)
        if let vc = bookCreateVC {
            if (vc.bookshelfs.count > 0) { //이미 선택된 게 있을 경우 거꾸로 책을 찾는다.
                
                for book in vc.bookshelfs {
                    for (i,e) in API.currentUser.bookShelf.enumerated() {
                        if (e.title == book.title) {
                            checked[i] = true;
                        }
                    }
                }
                
            }
        }
        print(checked)
        tableView.reloadData()
        super.viewDidLoad()
        navigationBar = NavigationBar(frame: CGRect.zero, title: "책장 선택")
        
        navigationBar.settingBtnHandler = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "bookshelf") as! BookShelfVC
            self.present(vc, animated: true, completion: nil)
            //self.performSegue(withIdentifier: "bookshelfSegue", sender: nil)
        }
        navigationBar.closeBtnHandler = {
            self.dismiss(animated: true, completion: nil)
        }
        
        
        self.view.addSubview(navigationBar)
        doneBtn = UIButton()
        doneBtn.setTitle("완료", for: .normal)
        doneBtn.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Bold", size: 15)
        doneBtn.setTitleColor(UIColor.mainColor, for: .normal)

        self.view.addSubview(doneBtn)
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 130),
            doneBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            doneBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 12)
            ])
        navigationBar.setConstraints()
        navigationBar.setToAnotherNavigation(sub: "여러 개도 선택할 수 있습니다.")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor, constant: 0)
            ])
        
        doneBtn.addTarget(self, action: #selector(doneBtnPressed(sender:)), for: .touchUpInside)
    }
    
    
    @objc func doneBtnPressed(sender: Any) {
        if let vc = bookCreateVC {
            vc.bookshelfs = [];
            for (index,element) in self.checked.enumerated() {
                if (element) {
                    vc.bookshelfs.append(API.currentUser.bookShelf[index])
                }
            }
            dismiss(animated: true, completion: nil)
        }
    }

}

extension BookShelfSelectingVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return API.currentUser.bookShelf.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = API.currentUser!.bookShelf[indexPath.row].title
        cell.selectionStyle = .none
        if (checked[indexPath.row]) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                checked[indexPath.row] = false
                
            } else {
                cell.accessoryType = .checkmark
                checked[indexPath.row] = true
            }
        }
    }
}
