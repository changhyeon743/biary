//
//  BookCell.swift
//  biary
//
//  Created by 이창현 on 28/10/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit
import SDWebImage
import AMPopTip

class MainTableCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var mainViewController = MainVC()

    var longPressedEnabled = false;
    
    var shelfInfo: Bookshelf?
    var shelfIndex = 0;
    var bookInfo: [Book] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(gesture:)))
        
        longPressGR.minimumPressDuration = 0.3
        longPressGR.delaysTouchesBegan = true
        self.collectionView.addGestureRecognizer(longPressGR)
        collectionView.setColorToGlobal()
    }
    
    var changed:CGPoint = CGPoint.zero
    
    @objc func longPressed(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                return
            }
            changed = gesture.location(in: collectionView)
            
            let cell = collectionView.cellForItem(at: selectedIndexPath) as! MainCollectionCell
            cell.startAnimate()
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            let point = gesture.location(in: collectionView)
            if ( changed.distance(toPoint: point) < 50 ) {
                //수정 툴팁 표시
//                let pop = PopTip()
//                guard let selectedIndexPath = collectionView.indexPathForItem(at: point) else {
//                    return
//                }
//                let cell = collectionView.cellForItem(at: selectedIndexPath) as! MainCollectionCell
//                pop.tapHandler = { popTip in
//                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookCreateVC") as! BookCreateVC
//                    vc.title = "책 편집하기"
//                    vc.bookInfo = self.bookInfo[selectedIndexPath.row];
//                    self.mainViewController.present(vc, animated: true, completion: nil)
//                }
//                //pop.bubbleColor = UIColor.mainColor
//                pop.padding = 10
//                pop.offset = 5
//                pop.backgroundColor = .darkGray
//                pop.shouldDismissOnTapOutside = true
//                pop.shouldDismissOnTap = true
//                pop.show(text: "수정", direction: .up , maxWidth: 200, in: self.collectionView, from: cell.frame)
            }
            
            collectionView.endInteractiveMovement()
            //doneBtn.isHidden = false
            
            longPressedEnabled = true
            
            //self.collectionView.reloadData()
        default:
            collectionView.cancelInteractiveMovement()
        }
//        if sender.state == UIGestureRecognizer.State.began {
//
//            let touchPoint = sender.location(in: self.collectionView)
//            if let indexPath = collectionView.indexPathForItem(at: touchPoint) {
//
//            }
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension MainTableCell: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "book", for: indexPath) as! MainCollectionCell
        
        
        if (bookInfo.count > 0) {
            if (bookInfo[indexPath.row].imageURL.isEmpty) {
                cell.imageView.image = imageWith(name: bookInfo[indexPath.row].title)
            } else {
                cell.imageView.sd_setImage(with: URL(string: bookInfo[indexPath.row].imageURL), completed: nil)
            }
        }
        
        
//        if longPressedEnabled   {
//            cell.startAnimate()
//        }else{
//            cell.stopAnimate()
//        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        mainViewController.gotoDetail(withBook: self.bookInfo[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 83, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if (mainViewController.friendMode) {
            return false
        } else {
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let tmp = bookInfo[sourceIndexPath.item]
        bookInfo[sourceIndexPath.item] = bookInfo[destinationIndexPath.item]
        bookInfo[destinationIndexPath.item] = tmp
        API.currentUser.bookShelf[shelfIndex].books = bookInfo.map{$0.token}
        collectionView.reloadData()
    }
    
    
}
