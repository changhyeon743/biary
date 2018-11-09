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
    var moreButton = UIButton()
    var peopleButton = UIButton()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContents()
        setConstraints()
    }
    
    func setContents() {
        titleLabel.text = "나미야 잡화점의 기적"
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textAlignment = .center
        
        backButton.setImage(UIImage(named:"arrow_back"), for: .normal)
        moreButton.setImage(UIImage(named:"more"), for: .normal)
        peopleButton.setImage(UIImage(named:"people"), for: .normal)
        
        
        self.addSubview(backButton)
        self.addSubview(titleLabel)
        self.addSubview(moreButton)
        self.addSubview(peopleButton)
    }
    
    func setConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        peopleButton.translatesAutoresizingMaskIntoConstraints = false
        
        //BackButton
        NSLayoutConstraint.activate([
            backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 14),
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        //TitleLabel
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        //MoreButton
        NSLayoutConstraint.activate([
            moreButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 14),
            moreButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        //MoreButton
        NSLayoutConstraint.activate([
            peopleButton.rightAnchor.constraint(equalTo: self.moreButton.leftAnchor, constant: 14),
            peopleButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func turnIntoClear() {
        self.backgroundColor = .clear
        self.titleLabel.textColor = .clear
        self.backButton.tintColor = .white
        self.moreButton.tintColor = .white
        self.peopleButton.tintColor = .white
    }
    
    func turnIntoWhite() {
        self.backgroundColor = .white
        self.titleLabel.textColor = .black
        self.backButton.tintColor = .black
        self.moreButton.tintColor = .black
        self.peopleButton.tintColor = .black
    }
    
    
    
}
