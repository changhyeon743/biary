//
//  NavigationBar.swift
//  biary
//
//  Created by 이창현 on 13/11/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import Foundation
import UIKit

class NavigationBar: UIView {
    
    var titleLbl = UILabel()
    var subLbl = UILabel()
    var line = UIView()
    
    var settingBtn = UIButton()
    var addBtn = UIButton()
    var searchBtn = UIButton()
    
    var closeBtn = UIButton()
    
    var settingBtnHandler:(()->Void)!
    var addBtnHandler:(()->Void)!
    var searchBtnHandler:(()->Void)!
    var closeBtnHandler:(()->Void)!
    

    
    init(frame:CGRect,title:String,subTitle:String="") {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        titleLbl.text = title;
        titleLbl.font = UIFont(name: "NotoSansCJKkr-Medium", size: 22)
        self.addSubview(titleLbl)
        
        subLbl.font = UIFont(name: "NotoSansCJKkr-Regular", size: 12)
        subLbl.isHidden = true
        self.addSubview(subLbl)
        
        line.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        line.isHidden = true
        
        self.addSubview(line)
        
        
        settingBtn.setImage(UIImage(named: "setting"), for: .normal)
        settingBtn.tintColor = UIColor.black
        settingBtn.addTarget(self, action: #selector(settingPressed), for: .touchUpInside)
        self.addSubview(settingBtn)
        
        addBtn.setImage(UIImage(named: "add"), for: .normal)
        addBtn.tintColor = UIColor.black
        addBtn.addTarget(self, action: #selector(addPressed), for: .touchUpInside)
        self.addSubview(addBtn)
        
        searchBtn.setImage(UIImage(named: "search"), for: .normal)
        searchBtn.tintColor = UIColor.black
        searchBtn.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        self.addSubview(searchBtn)
        
        closeBtn.setImage(UIImage(named: "close"), for: .normal)
        closeBtn.tintColor = UIColor.black
        closeBtn.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        closeBtn.isHidden = true
        self.addSubview(closeBtn)
//
//        let subTitleLbl = UILabel()
//        subTitleLbl.text = subTitle;
//        NSLayoutConstraint.activate([
//            subTitleLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5),
//            subTitleLbl.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 17)
//        ])
    }
    @objc func settingPressed() {
        self.settingBtnHandler()
    }
    @objc func addPressed() {
        self.addBtnHandler()
    }
    @objc func searchPressed() {
        self.searchBtnHandler()
    }
    @objc func closePressed() {
        self.closeBtnHandler()
    }
    
    var titleLeftAnchor:NSLayoutConstraint?
    
    func setConstraints() {
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        subLbl.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        settingBtn.translatesAutoresizingMaskIntoConstraints = false
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        searchBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.translatesAutoresizingMaskIntoConstraints = false

        titleLeftAnchor = titleLbl.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 17);
        
        NSLayoutConstraint.activate([
            titleLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 12),
            titleLeftAnchor!,
            
            settingBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5),
            addBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5),
            searchBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5),
            
            settingBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            addBtn.rightAnchor.constraint(equalTo: settingBtn.rightAnchor, constant: -16-20),
            searchBtn.rightAnchor.constraint(equalTo: addBtn.rightAnchor, constant: -16-20),
        ])
        
        
        
        NSLayoutConstraint.activate([
            line.leftAnchor.constraint(equalTo: self.leftAnchor),
            line.rightAnchor.constraint(equalTo: self.rightAnchor),
            line.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func setToAnotherNavigation(sub: String) {
        subLbl.isHidden = false
        closeBtn.isHidden = false
        settingBtn.isHidden = true
        searchBtn.isHidden = true
        addBtn.isHidden = true
        
        titleLbl.font = UIFont(name: "NotoSansCJKkr-Bold", size: 29)
        subLbl.textColor = UIColor(r: 90, g: 90, b: 90, alpha: 1)
        subLbl.text = sub
        
       titleLeftAnchor?.constant = 24
        
        NSLayoutConstraint.activate([
            closeBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 14),
            closeBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 17),
            closeBtn.widthAnchor.constraint(equalToConstant: 24),
            closeBtn.heightAnchor.constraint(equalToConstant: 24),
            
            
            subLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 2),
            subLbl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraint(onNavigationBarwithSuperView superView: UIView) {
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.topAnchor),
            self.leftAnchor.constraint(equalTo: superView.leftAnchor),
            self.rightAnchor.constraint(equalTo: superView.rightAnchor),
            self.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
    
}
