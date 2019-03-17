//
//  BookDetailVC.swift
//  biary
//
//  Created by 이창현 on 04/11/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit
import SDWebImage

class BookDetailVC: UIViewController {
    
    var customNavigationBar: DetailNavigationBar!
    
    @IBOutlet weak var tableView:UITableView!

    var headerView:DetailHeaderView!
    var headerOpacityView = UIView()
    
    var newHeaderLayer: CAShapeLayer!
    
    private var headerHeight: CGFloat = 250
    
    //data
    var bookInfo: Book!
    var contents: [Content] {
        get {
            if (bookInfo.writerToken == API.currentUser.token) { //자기 책일경우
                return API.currentContents.filter{$0.bookToken == self.bookInfo.token}
            } else {
                return API.currentShowingFriend!.contents.filter{$0.bookToken == self.bookInfo.token}
            }
        }
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        setNavigationBar()
        tabBarController?.tabBar.isHidden = true;
        headerHeight = UIWindow().screen.bounds.height * 0.4
        
        //ratio
        self.setUpHeaderView()
        tableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        headerHeight = UIWindow().screen.bounds.height * 0.4
        self.updateHeaderView()
        self.tableView.reloadData()
        
    }
    
    @IBAction func writeButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "write", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let writeVC = segue.destination as! WriteVC
        writeVC.bookInfo = self.bookInfo
    }
    
    func setNavigationBar() {
        customNavigationBar = DetailNavigationBar(frame: CGRect.zero)
        self.view.addSubview(customNavigationBar)
        
        
        customNavigationBar.backBtnHandler = {
            print("backButton button pressed")
            //self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
        customNavigationBar.moreBtnHandler = {
            print("More button pressed")
        }
        customNavigationBar.peopleBtnHandler = {
            print("People button pressed")
        }

        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            customNavigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            customNavigationBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func setUpHeaderView() {
        tableView.backgroundColor = UIColor.white
        headerView = tableView.tableHeaderView as? DetailHeaderView
        headerView.setUpView()
        
        headerView.title = bookInfo.title
        headerView.subTitle = bookInfo.author + " . " + bookInfo.publisher
        headerView.author = bookInfo.writerName
        headerView.date = bookInfo.date
        headerView.imageView.sd_setImage(with: URL(string: bookInfo.imageURL), completed: nil)
        
        
        tableView.tableHeaderView = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.addSubview(headerView)
        
        newHeaderLayer = CAShapeLayer()
        newHeaderLayer.fillColor = UIColor.black.cgColor
        headerView.layer.mask = newHeaderLayer
        
        let newheight = headerHeight
        tableView.contentInset = UIEdgeInsets(top: newheight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -newheight)
        headerView.setDescriptionViews(margin: -20)
        
        self.updateHeaderView()
    }
    
    func updateHeaderView() {
        let newheight = headerHeight
        var getheaderframe = CGRect(x: 0, y: -newheight, width: tableView.bounds.width, height: headerHeight)
        if tableView.contentOffset.y < newheight
        {
            getheaderframe.origin.y = tableView.contentOffset.y
            getheaderframe.size.height = -tableView.contentOffset.y
        }
        
        
        headerView.frame = getheaderframe
        let cutdirection = UIBezierPath()
        cutdirection.move(to: CGPoint(x: 0, y: 0))
        cutdirection.addLine(to: CGPoint(x: getheaderframe.width, y: 0))
        cutdirection.addLine(to: CGPoint(x: getheaderframe.width, y: getheaderframe.height))
        cutdirection.addLine(to: CGPoint(x: 0, y: getheaderframe.height))
        newHeaderLayer.path = cutdirection.cgPath
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tableView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    private var lastContentOffset:CGFloat = 0;
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
        
        if tableView.contentOffset.y > 0 {
            customNavigationBar.turnIntoWhite()
        } else {
            customNavigationBar.turnIntoClear()
        }
        
//        if (self.lastContentOffset > scrollView.contentOffset.y) {
//            if tableView.contentOffset.y > 0 {
//                customNavigationBar.turnIntoWhite()
//            }
//        }
//        else if (self.lastContentOffset < scrollView.contentOffset.y) {
//            customNavigationBar.turnIntoClear()
//        }
        
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
        
    }
    
    
    
}

extension BookDetailVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DetailCell
        cell.title = contents[indexPath.row].title
        cell.content = contents[indexPath.row].article
        cell.dateLabel.text = contents[indexPath.row].date.getDate()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WriteVC") as! WriteVC
        vc.bookInfo = self.bookInfo
        vc.contentInfo = self.contents[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
    
}
