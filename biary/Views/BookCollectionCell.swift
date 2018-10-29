//
//  BookCollectionCell.swift
//  biary
//
//  Created by 이창현 on 28/10/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit

class BookCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView:UIImageView!
    
    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 7
        self.layer.shadowOpacity = 0.5
        self.layer.shouldRasterize = true
        self.layer.masksToBounds = false
    }
}
