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
}

extension ExploreVC: ExploreDelegate {
    func sendAlert(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func sendViewToBack(view: BookView) {
        self.view.sendSubviewToBack(view)
        guard let url2 = API.currentBooks.randomElement() else {return}
        view.bookInfo = url2
    }
}

class ExploreVC: UIViewController {
    
    var navigationBar:NavigationBar!
    
    var bookImageView: BookView!
    var bookImageView2: BookView!

    
    override func viewDidLoad() {
        navigationBar = NavigationBar(frame: CGRect.zero, title: "탐험".localized)
        bookImageView = BookView(frame: CGRect.zero, image: UIImage(named: "more")!)
        bookImageView2 = BookView(frame: CGRect.zero, image: UIImage(named: "more")!)
        bookImageView.exploreDelegate = self
        bookImageView2.exploreDelegate = self
        
        
        navigationBar.settingBtn.isHidden = true
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
    
        guard let url = API.currentBooks.randomElement() else {return}
        bookImageView?.bookInfo = url
        guard let url2 = API.currentBooks.randomElement() else {return}
        bookImageView2.bookInfo = url2
    }
}
