//
//  BookCell.swift
//  biary
//
//  Created by 이창현 on 07/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit
import PeekPop
import Spring
class BookCell: UITableViewCell {

    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var explainLbl: UILabel!
    
    
    @IBOutlet weak var bookImageView: UIImageView!
    
    
    var bookTitle = "무제"{
        didSet {
            titleLbl.text = bookTitle;
        }
    }
    
    var subTitle = "부제"{
        didSet {
            subTitleLbl.text = subTitle;
        }
    }
    
    var explain = "없습니다."{
        didSet {
            explainLbl.text = explain;
        }
    }

    var imgLink = "" {
        didSet {
            bookImageView.sd_setImage(with: URL(string: imgLink), completed: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
