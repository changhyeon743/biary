//
//  FriendTableCell.swift
//  biary
//
//  Created by 이창현 on 16/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit


class FriendTableCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    //var friendVC:FriendsVC!
    var friendDelegate: FriendsDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}


extension FriendTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return API.currentFriends.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FriendCell

        cell.imageView.sd_setImage(with: URL(string: API.currentFriends[indexPath.row].profileURL), completed: nil)
        cell.nameLbl.text = API.currentFriends[indexPath.row].name

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        friendDelegate?.selectItem(indexPath: indexPath)
        
        
    }

}
