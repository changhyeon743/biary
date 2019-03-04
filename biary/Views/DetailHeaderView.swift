//
//  BookDetailHeader.swift
//  biary
//
//  Created by 이창현 on 04/11/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit

class DetailHeaderView: UIView {
    
    var imageView:UIImageView!
    var colorView:UIView!
    var bgColor = UIColor(red: 235/255, green: 96/255, blue: 91/255, alpha: 1)
    
    
    //Description
    private var titleLbl = UILabel()
    private var subTitleLbl = UILabel()
    private var authorLbl = UILabel()
    private var dateLbl = UILabel()
    
    var title:String = "" {
        didSet {titleLbl.text = title}
    }
    var subTitle:String = "" {
        didSet {subTitleLbl.text = subTitle}
    }
    var author:String = "" {
        didSet {authorLbl.text = author}
    }
    var date:Date = Date() {
        didSet {
            dateLbl.text = date.getRealDate()
        }
    }
    
    
    func setUpView() {
        self.backgroundColor = .white
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        colorView = UIView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(colorView)
        let constraints:[NSLayoutConstraint] = [
            //set constraints all side of self view
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            colorView.topAnchor.constraint(equalTo: self.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        imageView.image = UIImage(named: "ssss")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        colorView.backgroundColor = UIColor.black
        colorView.alpha = 0.6
        
        
        
        
        //        articleIcon = UIImageView()
        //        articleIcon.translatesAutoresizingMaskIntoConstraints = false
        //        self.addSubview(articleIcon)
        //        let imageConstraints:[NSLayoutConstraint] = [
        //            articleIcon.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor),
        //            articleIcon.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor, constant: 6),
        //            articleIcon.widthAnchor.constraintEqualToConstant(40),
        //            articleIcon.heightAnchor.constraintEqualToConstant(40)
        //        ]
        //        NSLayoutConstraint.activateConstraints(imageConstraints)
        //        articleIcon.image = UIImage(named: "article")
    }
    
    func setDescriptionViews(margin:CGFloat) {
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLbl)
        titleLbl.font = UIFont(name: "NotoSansCJKkr-Bold", size: 20)
        titleLbl.textColor = UIColor.white
        
        subTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subTitleLbl)
        subTitleLbl.font = UIFont(name: "NotoSansCJKkr-Regular", size: 11)
        subTitleLbl.textColor = UIColor(r: 255, g: 255, b: 255, alpha: 0.8)
        
        authorLbl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(authorLbl)
        authorLbl.font = UIFont(name: "NotoSansCJKkr-Regular", size: 11)
        authorLbl.textColor = UIColor(r: 255, g: 255, b: 255, alpha: 0.8)
        
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(dateLbl)
        dateLbl.font = UIFont(name: "NotoSansCJKkr-Regular", size: 11)
        dateLbl.textColor = UIColor(r: 255, g: 255, b: 255, alpha: 0.8)
        dateLbl.textAlignment = .right
        
        
        
        let horizontalMargin:CGFloat = 20;
        NSLayoutConstraint.activate([
            authorLbl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: horizontalMargin),
            authorLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            
            subTitleLbl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: horizontalMargin),
            subTitleLbl.bottomAnchor.constraint(equalTo: authorLbl.topAnchor, constant: -24),
            
            titleLbl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: horizontalMargin),
            titleLbl.bottomAnchor.constraint(equalTo: subTitleLbl.topAnchor, constant: -5),
            
            dateLbl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -horizontalMargin),
            dateLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
    }
    
    
}
