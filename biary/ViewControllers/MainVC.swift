//
//  MainVC.swift
//  biary
//
//  Created by 이창현 on 26/10/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    func setNavigationBar() {
        //self.tabBarController?.navigationItem.title = "나의 서재"
        if let navController = navigationController {
           // Do any additional setup after loading the view.
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            titleLabel.text = "나의 서재"
            titleLabel.textColor = UIColor.black
            titleLabel.font = UIFont.systemFont(ofSize: 22,weight: .semibold)
            
            navigationItem.titleView = titleLabel
//
//            navController.navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
            
            title = "나의 서재"
            
            navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
//            navController.navigationBar.shadowImage = UIImage()
//            navController.navigationBar.isTranslucent = true
            //navController.view.backgroundColor = .clear
        }
    }
    
}


extension MainVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! BookTableCell
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BookTableCell
        
        return cell.collectionView.collectionViewLayout.collectionViewContentSize.height+cell.titleLabel.frame.height+24+12+12
    }
    
}
