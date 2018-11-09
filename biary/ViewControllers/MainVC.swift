//
//  MainVC.swift
//  biary
//
//  Created by 이창현 on 26/10/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit
import UINavigationItem_Margin

class MainVC: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    
    let sectionCount = 5
    
    let headerHeight:CGFloat = 40;
    
    var expandedData = [true,true,true,true,true]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.tableView.reloadData()
    }
}


extension MainVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expandedData[section] {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return expandedData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 68))
        view.backgroundColor = .white
        
        
        
        let label = UILabel(frame: CGRect(x: 17, y: 0, width: 200, height: headerHeight))
        label.text = "소설"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        let expandImage = UIImage(named: "arrow_back")!
        let button = UIButton(frame: CGRect(x: self.view.frame.width - expandImage.size.width - 12, y: expandImage.size.height/2, width: expandImage.size.width, height: expandImage.size.height))
        button.tintColor = 
        button.setImage(expandImage, for: .normal)
        
        //button.setTitle("", for: .normal)
        turn(button: button, to: CGFloat(Double.pi / 2))
        
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        
        button.tag = section
        
        view.addSubview(button)
        view.addSubview(label)
        
        return view
        
    }
    
    func turn(button:UIButton,to:CGFloat) {
        if let temp = button.imageView {
            temp.transform = temp.transform.rotated(by: to);
        }
    }
    
    @objc func handleExpandClose(button: UIButton) {
        let indexPaths = [IndexPath(row: 0, section: button.tag)]
        
        //Change
        expandedData[button.tag] = !expandedData[button.tag]
        
        if (expandedData[button.tag]) {
            tableView.insertRows(at: indexPaths, with: .automatic)
            turn(button: button, to: CGFloat(Double.pi))
        } else {
            tableView.deleteRows(at: indexPaths, with: .automatic)
            turn(button: button, to: CGFloat(Double.pi))
        }
        
        //button.setTitle(expandedData[button.tag] ? "Close" : "Open", for: .normal)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! MainTableCell
        cell.mainViewController = self
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BookTableCell
//
//        return cell.collectionView.collectionViewLayout.collectionViewContentSize.height+cell.titleLabel.frame.height+24+12+12
//    }
    
}
