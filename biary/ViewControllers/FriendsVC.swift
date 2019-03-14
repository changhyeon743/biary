//
//  FriendsVC.swift
//  biary
//
//  Created by 이창현 on 03/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit

class FriendsVC: UIViewController {
    var navigationBar:NavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar = NavigationBar(frame: CGRect.zero, title: "탐험")
        
        navigationBar.settingBtnHandler = {
            self.collectionView.reloadData()
        }
        
        navigationBar.settingBtn.isHidden = false
        navigationBar.addBtn.isHidden = true
        navigationBar.searchBtn.isHidden = true
        navigationBar.setConstraints()
        self.view.addSubview(navigationBar)
        
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 80)
            ])
        
        print(navigationBar)
    }
    

    

}

extension FriendsVC: UICollectionViewDelegate, UICollectionViewDataSource {
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
        API.User.fetch_friends(friends: [API.currentFriends[indexPath.row].facebookId]) { (json) in
            API.currentShowingFriend = Info.make(data: json["data"][0])
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            
//            vc.navigationBar.titleLbl.text = API.currentShowingFriend?.user.name ?? "" + "의 서재"
//
            vc.friendMode = true
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
