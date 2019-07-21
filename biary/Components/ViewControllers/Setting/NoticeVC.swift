//
//  NoticeVC.swift
//  biary
//
//  Created by 이창현 on 30/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit

struct Notice {
    var title: String
    var article: String
    var date: Date
}

class NoticeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var navigationBar: NavigationBar!
    
    var notices: [Notice] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar = NavigationBar(frame: CGRect.zero, title: "공지사항".localized)
        if title != nil {
            navigationBar.titleLbl.text = title!
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

}

extension NoticeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = notices[indexPath.row].title
        cell?.detailTextLabel?.text = notices[indexPath.row].article
        return cell!
    }
    
    
}
