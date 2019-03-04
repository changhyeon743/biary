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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar = NavigationBar(frame: CGRect.zero, title: "탐험")
        
        navigationBar.settingBtn.isHidden = false
        navigationBar.addBtn.isHidden = true
        navigationBar.searchBtn.isHidden = true
        navigationBar.setConstraints()
        self.view.addSubview(navigationBar)
        
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 80)
            ])
        
        print(navigationBar)
    }
    

    

}
