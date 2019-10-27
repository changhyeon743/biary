//
//  DetailCell.swift
//  biary
//
//  Created by 이창현 on 07/11/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var contentLabel:UILabel!
    
    var title = "무제"{
        didSet {
            titleLabel.text = title;
        }
    }
    
    var date = "방금 전"{
        didSet {
            dateLabel.text = date;
        }
    }
    
    var content = "없습니다."{
        didSet {
            contentLabel.text = content;
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        dateLabel.isHidden = true
        // Initialization code
    }

    
}
