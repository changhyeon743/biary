//
//  ExploreVC.swift
//  
//
//  Created by 이창현 on 05/08/2019.
//

import Foundation
import UIKit
import SDWebImage

protocol ExploreDelegate {
    func sendViewToBack(view: BookView)
    func sendAlert(alert: UIAlertController)
    func show(bookInfo: Book)
    func search(bookInfo: Book)
}

extension ExploreVC: ExploreDelegate {
    func search(bookInfo: Book) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookAddSearchVC") as! BookAddSearchVC
        self.present(vc, animated: true) {
            vc.searchField.text = bookInfo.isbn
            vc.search()
        }
        
    }
    
    func sendAlert(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func sendViewToBack(view: BookView) {
        getRandomBook { (book) in
            if (book.isPublic == true) {
                self.bookList.append(book)
                
                view.bookInfo = self.bookList[self.currentIndex]
                self.currentIndex += 1
            } else {
                self.sendViewToBack(view: view)
            }
        }
        self.view.sendSubviewToBack(view)
        //guard let url2 = API.currentBooks.randomElement() else {return}
    }
    
    func sendViewToFront(view: BookView,book: Book) {
        view.bookInfo = book
        self.view.bringSubviewToFront(view)
        //guard let url2 = API.currentBooks.randomElement() else {return}
    }
    
    func show(bookInfo: Book) {
        indicator?.start()
        API.book.getContent(ofToken: bookInfo.token) { (json) in
            self.indicator?.stop()
            API.currentShowingFriend = Info(user: nil, books: [], contents: Content.transformContent(fromJSON: json))
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookDetailVC") as! BookDetailVC
            vc.bookInfo = bookInfo
            vc.bookInfo.writerName = "아무개씨".localized
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension ExploreVC {
    func getRandomBook(completion:@escaping (Book)->Void) {
        API.user.getRandomBook { (json) in
            completion(Book.transformBook(fromJSON: json))
        }
        
    }
    
}

class ExploreVC: UIViewController {
    var indicator : IndicatorView?

    var navigationBar:NavigationBar!
    
    var bookImageView: BookView!
    var bookImageView2: BookView!
    
    var bookList: [Book] = []
    var currentIndex = 0;
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
        indicator = IndicatorView(uiView: self.view)

        
        navigationBar = NavigationBar(frame: CGRect.zero, title: "탐험".localized)
        bookImageView = BookView(frame: CGRect.zero, image: UIImage(named: "more")!)
        bookImageView2 = BookView(frame: CGRect.zero, image: UIImage(named: "more")!)
        bookImageView.exploreDelegate = self
        bookImageView2.exploreDelegate = self
        
        
        navigationBar.settingBtn.isHidden = true
        navigationBar.settingBtn.setImage(UIImage(named: "undo"), for: .normal)
        navigationBar.settingBtnHandler = {
            
            if (self.bookList.count > 2) {
                //print(self.bookList.debugDescription)
                //self.bookList.removeLast()
                self.currentIndex -= 1

                self.sendViewToFront(view: self.bookImageView, book: self.bookList[self.currentIndex])
            }
            
        }
        
        navigationBar.line.isHidden = false
        navigationBar.addBtn.isHidden = true
        navigationBar.searchBtn.isHidden = true
        self.view.addSubview(navigationBar)
        
        self.view.addSubview(bookImageView)
        self.view.addSubview(bookImageView2)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        bookImageView.translatesAutoresizingMaskIntoConstraints = false
        bookImageView2.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.setConstraints()
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 80),
            
            bookImageView.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor),
            bookImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bookImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bookImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            bookImageView2.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor),
            bookImageView2.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bookImageView2.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bookImageView2.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            ])
    
        sendViewToBack(view: bookImageView)
        sendViewToBack(view: bookImageView2)
    }
}
