//
//  image.swift
//  biary
//
//  Created by 이창현 on 09/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import UIKit

func imageWith(name: String?) -> UIImage? {
    let frame = CGRect(x: 0, y: 0, width: 70, height: 128)
    
    let nameLabel = UILabel(frame: CGRect(x: 4, y: 0, width: 76, height: 128))
    nameLabel.textAlignment = .center
    nameLabel.backgroundColor = .lightGray
    nameLabel.textColor = .white
    nameLabel.font = UIFont(name: "Noto Sans CJK KR Regular", size: 7)
    nameLabel.text = name
    nameLabel.numberOfLines = 2
    UIGraphicsBeginImageContext(frame.size)
    if let currentContext = UIGraphicsGetCurrentContext() {
        nameLabel.layer.render(in: currentContext)
        let nameImage = UIGraphicsGetImageFromCurrentImageContext()
        return nameImage
    }
    return nil
}
