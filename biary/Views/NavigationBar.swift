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
    var line = UIView()
    
    init(frame:CGRect,title:String,subTitle:String="") {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        titleLbl.text = title;
        titleLbl.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        
        self.addSubview(titleLbl)
        
        line.backgroundColor = UIColor(r: 217, g: 217, b: 217)
       
        self.addSubview(line)
        
//
//        let subTitleLbl = UILabel()
//        subTitleLbl.text = subTitle;
//        NSLayoutConstraint.activate([
//            subTitleLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5),
//            subTitleLbl.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 17)
//        ])
    }
    
    func setConstraints() {
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5),
            titleLbl.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 17)
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
            self.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
}
