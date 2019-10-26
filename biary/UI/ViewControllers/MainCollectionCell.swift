//
//  BookCollectionCell.swift
//  biary
//
//  Created by 이창현 on 28/10/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit

class MainCollectionCell: UICollectionViewCell,UIGestureRecognizerDelegate {
    
    var isAnimate: Bool! = true
    
    @IBOutlet weak var imageView:UIImageView!

    
    override func awakeFromNib() {
        
        if #available(iOS 13.0, *) {
            self.layer.shadowColor = UIColor.systemGray5.cgColor
        } else {
            self.layer.shadowColor = UIColor.lightGray.cgColor
            // Fallback on earlier versions
        }
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
//
        //self.imageView.layer.cornerRadius = 5
        self.imageView.clipsToBounds = true
//
//        if (traitCollection.forceTouchCapability == .available) {
//            registerfor
//        }
        
    }
    
    func startAnimate() {
//        let shakeAnimation = CABasicAnimation(keyPath: "transform.scale")
//        shakeAnimation.duration = 0.2
//        shakeAnimation.setAnima
//
//        shakeAnimation.fromValue = NSNumber(value: 1.0)
//        shakeAnimation.toValue = NSNumber(value: 1.3)
//
//        let layer: CALayer = self.layer
//        layer.add(shakeAnimation, forKey:"animate")
        //removeBtn.isHidden = false
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction, .curveEaseIn], animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
        isAnimate = true
    }
    
    func stopAnimate() {
//        let layer: CALayer = self.layer
//        layer.removeAnimation(forKey: "animate")
        //self.removeBtn.isHidden = true
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut], animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
        isAnimate = false
    }
    
}
