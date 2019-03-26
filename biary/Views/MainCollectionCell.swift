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
        
//        self.layer.shadowColor = UIColor.gray.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.layer.shadowRadius = 6
//        self.layer.shadowOpacity = 0.6
//        self.layer.masksToBounds = false
//
        self.imageView.layer.cornerRadius = 5
        self.imageView.clipsToBounds = true
//
//        if (traitCollection.forceTouchCapability == .available) {
//            registerfor
//        }
        
    }
    
    func startAnimate() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.2
        shakeAnimation.repeatCount = 99999
        
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.timeOffset = 290 * drand48()
        
        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey:"animate")
        //removeBtn.isHidden = false
        isAnimate = true
    }
    
    func stopAnimate() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "animate")
        //self.removeBtn.isHidden = true
        isAnimate = false
    }
    
}
