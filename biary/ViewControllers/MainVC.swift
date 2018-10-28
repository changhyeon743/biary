//
//  MainVC.swift
//  biary
//
//  Created by 이창현 on 26/10/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    var subTitle:UILabel!
    @IBOutlet weak var tableView:UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationBar()
        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 80
    }
    
    func makeNavigationBar() {
        if let navController = navigationController {
            Navigation.clear(forBar: navController.navigationBar)
            navController.view.backgroundColor = .clear
            makeSubTitle(withString: "총 26권의 책이 있습니다.")
        }
    }
    
    func makeSubTitle(withString str:String) {
        self.subTitle = UILabel(frame: CGRect(x: 34, y: 78, width: 200, height: 18))
        self.subTitle?.textColor = UIColor.gray
        self.subTitle?.text = str
        
        self.navigationController?.navigationBar.addSubview(self.subTitle)
        
        if let titleFrame:CGRect = self.navigationItem.titleView?.frame {
            
            
        }
    }
    


}


extension MainVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! BookTableCell
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BookTableCell
        return cell.collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
}
