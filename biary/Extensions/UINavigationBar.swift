//
//  UINavigationBar.swift
//  biary
//
//  Created by 이창현 on 01/11/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        print("absbs")
        return CGSize(width: UIScreen.main.bounds.size.width, height: 200.0)
        
    }
    
}
