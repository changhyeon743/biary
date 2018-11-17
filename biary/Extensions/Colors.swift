//
//  Colors.swift
//  biary
//
//  Created by 이창현 on 09/11/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    
    /// Creates an instance of UIColor based on an RGB value.
    ///
    /// - parameter rgbValue: The Integer representation of the RGB value: Example: 0xFF0000.
    /// - parameter alpha:    The desired alpha for the color.
    convenience init(rgbValue: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public convenience init(r: Int, g: Int, b: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    static let Gray = UIColor(r: 112, g: 112, b: 112)
    
    static let mainColor = UIColor(r: 188, g: 140, b: 94)
}
