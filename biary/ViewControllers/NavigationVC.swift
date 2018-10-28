//
//  NavigationVC.swift
//  biary
//
//  Created by 이창현 on 26/10/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit

class NavigationVC: UINavigationController {

}

struct Navigation {
    static func clear(forBar navBar: UINavigationBar) {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
    }
}
