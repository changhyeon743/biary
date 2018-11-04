//
//  stickyNavigationBar.swift
//  biary
//
//  Created by 이창현 on 04/11/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit

class stickyNavigationBar: UIView {

    var backButton:UIButton!
    
    func turnIntoClear() {
        self.backgroundColor = .clear
        self.backButton.tintColor = .white
    }
    
    func turnIntoWhite() {
        self.backgroundColor = .white
        self.backButton.tintColor = .black
    }
}
