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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar = NavigationBar(frame: CGRect.zero, title: "책장 선택")
        
        navigationBar.settingBtnHandler = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "bookshelf") as! BookShelfVC
            self.present(vc, animated: true, completion: nil)
            //self.performSegue(withIdentifier: "bookshelfSegue", sender: nil)
        }
        
        
        self.view.addSubview(navigationBar)
        doneBtn = UIButton()
        doneBtn.setTitle("완료", for: .normal)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 130),
            doneBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 16),
            doneBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20)
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
        
        
        
        navigationBar.settingBtn.isHidden = false
    }
    



}

extension BookShelfSelectingVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return API.currentUser.bookShelf.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = API.currentUser!.bookShelf[indexPath.row].title
        
        return cell;
    }
    
    
}
