//
//  ViewController.swift
//  biary
//
//  Created by 이창현 on 27/02/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setBackGroundColorToSystem() {
//        
//        if #available(iOS 13.0, *) {
//            self.backgroundColor = .systemBackground
//        } else {
//            // Fallback on earlier versions
//            self.backgroundColor = .white
//        }
    }
}

extension UITextField {
    func addBorderBottom(height: CGFloat, color: UIColor, margin_right: CGFloat) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height-height, width: self.frame.width - margin_right, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}

extension String {
    public var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
}
