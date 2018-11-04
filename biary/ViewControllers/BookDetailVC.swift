//
//  BookDetailVC.swift
//  biary
//
//  Created by 이창현 on 04/11/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit

class BookDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var headerView:BookDetailHeaderView!
    var headerHeightConstraint:NSLayoutConstraint!
    let headerHeight:CGFloat = 250
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        setUpHeader()
        setUpTableView()
    }
    
    func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let constraints:[NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
    func setUpHeader() {
        headerView = BookDetailHeaderView(frame: CGRect.zero, title: "Articles")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: headerHeight)
        headerHeightConstraint.isActive = true
        //top, left, right, and height on 150
        let constraints:[NSLayoutConstraint] = [
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

}

extension BookDetailVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "텍스트"
        return cell!
    }
    
    
}

extension BookDetailVC:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            self.headerHeightConstraint.constant += abs(scrollView.contentOffset.y)/2
        } else if scrollView.contentOffset.y > 0 && headerHeightConstraint.constant > 0 {
            self.headerHeightConstraint.constant -= abs(scrollView.contentOffset.y)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.headerHeightConstraint.constant > headerHeight {
            animateHeader()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.headerHeightConstraint.constant > headerHeight {
            animateHeader()
        }
    }
    
    
    func animateHeader() {
        
        self.headerHeightConstraint.constant = headerHeight
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
}


