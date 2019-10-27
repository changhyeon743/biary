//
//  BookView.swift
//  biary
//
//  Created by 이창현 on 05/08/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import UIKit

class BookView: UIView {
    var panGesture      = UIPanGestureRecognizer()
    var imageView       = UIImageView(frame: CGRect.zero)
    var center_: CGPoint {
        return CGPoint(x: self.frame.width/2, y: self.frame.height/2)
    }
    var weight:CGFloat   = 2;
    let inset:CGFloat = 64;
    
    var exploreDelegate: ExploreDelegate?
    
    var bookInfo: Book? {
        willSet(newVal) {
            guard let url = newVal?.imageURL else {return}
            self.imageView.sd_setImage(with: URL(string: url), completed: nil)
        }
    }
    
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        imageView = UIImageView(image: image)
        self.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //tableView.translatesAutoresizingMaskIntoConstraints = false
        if (hasTopNotch) {
            weight = 2.7
        }
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 105*weight),
            imageView.heightAnchor.constraint(equalToConstant: 154*weight),
//            imageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,constant: inset*2.5),
//            imageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant: inset*1.3),
//            imageView.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -inset*1.3),
//            imageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: -inset*1.5),
            
            ])
        if #available(iOS 13.0, *) {
            self.layer.shadowColor = UIColor.systemGray4.cgColor
        } else {
            self.layer.shadowColor = UIColor.lightGray.cgColor
            // Fallback on earlier versions
        }
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.6
        self.layer.masksToBounds = false
        
        self.imageView.clipsToBounds = true
        
        
        
        setDragAndDrop()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var origin: CGPoint = CGPoint.zero
    func setDragAndDrop() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        self.isUserInteractionEnabled = true
        imageView.isUserInteractionEnabled = true
        self.addGestureRecognizer(panGesture)
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        guard let book = bookInfo else {return}
        let alert = UIAlertController(title: book.title, message: book.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "내 책장에 추가하기".localized, style: .destructive, handler: { (_) in
            if let book = self.bookInfo {
                self.exploreDelegate?.search(bookInfo: book)
                
            }
        }))
        alert.addAction(UIAlertAction(title: "자세히 보기".localized, style: .default, handler: { _ in
            if let book = self.bookInfo {
                self.exploreDelegate?.show(bookInfo: book)
                
            }
        }))
        
        alert.addAction(UIAlertAction(title: "확인".localized, style: .cancel, handler: nil))

        exploreDelegate?.sendAlert(alert: alert)
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        self.bringSubviewToFront(imageView)
        let translation = sender.translation(in: self)
        imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self)
        
        let currentLocation = sender.location(in: self)
        
        let dx = currentLocation.x - origin.x;
        let dy = currentLocation.y - origin.y;
        let distance = sqrt(dx*dx + dy*dy );
        
//        var dir:CGFloat = 0
//        if (dx > 0) {dir = 1}
//        if (dx < 0) {dir = -1}
        
        if (sender.state != .began) {
            imageView.transform = CGAffineTransform(rotationAngle: 2 * CGFloat.pi * (1 +  distance/3500) * (dx / 3000))
            //print(1 - distance / 500)
            imageView.alpha = 1 - distance / 500
        }
        
        
        switch sender.state {
        case .began:
            origin = currentLocation
        case .ended:
            if (distance < 100){
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                        self.imageView.center = self.center_
                        self.imageView.transform = CGAffineTransform(rotationAngle: 2*CGFloat.pi)
                        self.imageView.alpha = 1

                    }, completion: nil)
                }
            } else {
                //let velocity = sender.velocity(in: self);
                self.exploreDelegate?.sendViewToBack(view: self)

                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                        self.imageView.center = CGPoint(x: dx*4, y: dy*4)

                    }, completion: {_ in
                        self.imageView.center = self.center_
                        self.imageView.transform = CGAffineTransform(rotationAngle: 2*CGFloat.pi)
                        self.imageView.alpha = 1
                        
                    })
                }
                
            }
            origin = CGPoint.zero
        default:
            break;
        }
        
        
    }
}

