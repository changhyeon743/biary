//
//  Poptip.swift
//  biary
//
//  Created by 이창현 on 29/06/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import AMPopTip

class CustomPopTip: PopTip {
    
    func show( text: String, direction: PopTipDirection, to: UIView, from: CGRect, offset: CGFloat = 5) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.shouldDismissOnTap = true
            self.bubbleColor = UIColor.mainColor
            self.padding = 10
            self.offset = offset
            self.show(text: text, direction: direction, maxWidth: 200, in: to, from: from)
        }
        
    }
}

extension UIBarButtonItem {
    
    var frame: CGRect? {
        guard let view = self.value(forKey: "view") as? UIView else {
            return nil
        }
        return view.frame
    }
    
}
