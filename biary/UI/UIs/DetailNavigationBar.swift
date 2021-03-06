//
//  stickyNavigationBar.swift
//  biary
//
//  Created by 이창현 on 04/11/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit

class DetailNavigationBar: UIView {

    var backButton = UIButton()
    var backBtnHandler:(()->Void)!
    
    var titleLabel = UILabel()
    
    var moreButton = UIButton()
    var moreBtnHandler:(()->Void)!
    
    var peopleButton = UIButton()
    var peopleBtnHandler:(()->Void)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContents()
        setConstraints()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setContents() {
        titleLabel.text = "책 이름"
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        titleLabel.textAlignment = .center
        
        backButton.setImage(UIImage(named:"arrow_back"), for: .normal)
        moreButton.setImage(UIImage(named:"more"), for: .normal)
        //peopleButton.setImage(UIImage(named:"people"), for: .normal)
        
        backButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        peopleButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        self.addSubview(backButton)
        self.addSubview(titleLabel)
        self.addSubview(moreButton)
        self.addSubview(peopleButton)
    }
    @objc func buttonAction(_ button:UIButton) {
        switch button {
        case backButton:
            self.backBtnHandler();
            break;
        case moreButton:
            self.moreBtnHandler();
            break;
        case peopleButton:
            self.peopleBtnHandler();
            break;
        default:
            break;
        }
    }
    
    
    func setConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        peopleButton.translatesAutoresizingMaskIntoConstraints = false
        
        //BackButton
        NSLayoutConstraint.activate([
            backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 8),
        //TitleLabel
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: 6),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 48),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -96),
        //MoreButton
            moreButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            moreButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 8),
        //People
            peopleButton.rightAnchor.constraint(equalTo: self.moreButton.leftAnchor, constant: -16),
            peopleButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 8),
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
        if #available(iOS 13.0, *) {
            self.backgroundColor = .systemGray6
            self.titleLabel.textColor = .label
            self.backButton.tintColor =  UIColor(named: "NavigationButtons")
            self.moreButton.tintColor =  UIColor(named: "NavigationButtons")
            self.peopleButton.tintColor =  UIColor(named: "NavigationButtons")
        } else {
            // Fallback on earlier versions
            self.backgroundColor = .white
            self.titleLabel.textColor = .black
            self.backButton.tintColor = .black
            self.moreButton.tintColor = .black
            self.peopleButton.tintColor = .black
        }
        
    }
    
    
    
}
