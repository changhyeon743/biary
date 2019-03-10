//
//  BookCell.swift
//  biary
//
//  Created by 이창현 on 28/10/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit
import SDWebImage

class MainTableCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var mainViewController = MainVC()

    var shelfInfo: Bookshelf?
    var bookInfo: [Book] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        longPressGR.minimumPressDuration = 0.3
        longPressGR.delaysTouchesBegan = true
        self.collectionView.addGestureRecognizer(longPressGR)
    
    }
    
    
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            
            let touchPoint = sender.location(in: self.collectionView)
            if let indexPath = collectionView.indexPathForItem(at: touchPoint) {
                let cb = bookInfo[indexPath.row];
                let actionSheet = UIAlertController(title: cb.title, message: cb.description, preferredStyle: .actionSheet)
                let action = UIAlertAction(title: "공유", style: .default, handler: { _ in
                })
                
//                let image = UIImage(named: "ssss")
//                actionSheet.setValue(image?.withRenderingMode(.alwaysOriginal), forKey: "image")
                actionSheet.addAction(action)
                actionSheet.addAction(UIAlertAction(title: "편집", style: .default, handler: { _ in
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookCreateVC") as! BookCreateVC
                    vc.bookInfo = cb;
                    self.mainViewController.present(vc, animated: true, completion: nil)
                }))
                
                actionSheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                    let real = UIAlertController(title: "정말 삭제하시겠습니까?", message: "삭제한 책은 복구할 수 없습니다.", preferredStyle: .alert);
                    real.addAction(UIAlertAction(title: "삭제", style: UIAlertAction.Style.destructive, handler: { _ in
                        Book.delete(withToken: cb.token);
                    }))
                    real.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
                    self.mainViewController.present(real, animated: true, completion: nil)
                }))
                
                actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                
                
                self.mainViewController.present(actionSheet, animated: true, completion: nil)

                print("Long pressed row: \(indexPath.row)")
            }
        }
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
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        mainViewController.gotoDetail(withBook: self.bookInfo[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 83, height: 128)
    }
    
    
    
    
}
