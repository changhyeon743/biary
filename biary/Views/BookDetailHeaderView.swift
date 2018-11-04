//
//  BookDetailHeader.swift
//  biary
//
//  Created by 이창현 on 04/11/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit

class BookDetailHeaderView: UIView {
    
    var imageView:UIImageView!
    var colorView:UIView!
    var bgColor = UIColor(red: 235/255, green: 96/255, blue: 91/255, alpha: 1)
    var titleLabel = UILabel()
    
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
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(titleLabel)
        let titlesConstraints:[NSLayoutConstraint] = [
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 28),
            ]
        NSLayoutConstraint.activate(titlesConstraints)
        
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .center
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
    

}
