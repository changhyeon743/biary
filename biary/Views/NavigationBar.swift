//
//  NavigationBar.swift
//  biary
//
//  Created by 이창현 on 13/11/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import Foundation
import UIKit
import SwiftSVG

class NavigationBar: UIView {
    
    var titleLbl = UILabel()
    var line = UIView()
    
    var settingBtn = UIButton()
    var addBtn = UIButton()
    var searchBtn = UIButton()
    
    var settingBtnHandler:(()->Void)!
    var addBtnHandler:(()->Void)!
    var searchBtnHandler:(()->Void)!
    
    init(frame:CGRect,title:String,subTitle:String="") {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        titleLbl.text = title;
        titleLbl.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        
        self.addSubview(titleLbl)
        
        line.backgroundColor = UIColor(r: 217, g: 217, b: 217)
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
    
    func setConstraints() {
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        settingBtn.translatesAutoresizingMaskIntoConstraints = false
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        searchBtn.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5),
            titleLbl.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 17),
            
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
