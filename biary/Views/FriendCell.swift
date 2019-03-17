//
//  FriendCell.swift
//  biary
//
//  Created by 이창현 on 10/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit

class FriendCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        //imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        //imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
    }
}
