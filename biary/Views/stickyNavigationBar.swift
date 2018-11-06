//
//  stickyNavigationBar.swift
//  biary
//
//  Created by 이창현 on 04/11/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit

class stickyNavigationBar: UIView {

    var backButton = UIButton()
    var titleLabel = UILabel()

    
    override init(frame: CGRect) {
        titleLabel.text = "나미야 잡화점의 기적"
        backButton = UIButton(type: .infoLight)
        super.init(frame: frame)
        setUpView()
    }
    
    func setUpView() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(backButton)
        let backButtonConstraints:[NSLayoutConstraint] = [
            backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 14),
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ]
        NSLayoutConstraint.activate(backButtonConstraints)
        
        
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textAlignment = .center
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(titleLabel)
        let titlesConstraints:[NSLayoutConstraint] = [
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ]
        NSLayoutConstraint.activate(titlesConstraints)
        
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func turnIntoClear() {
        self.backgroundColor = .clear
        self.titleLabel.textColor = .clear
        self.backButton.tintColor = .white
    }
    
    func turnIntoWhite() {
        self.backgroundColor = .white
        self.titleLabel.textColor = .black
        self.backButton.tintColor = .black
    }
    
    
    
}
