//
//  BookDetailVC.swift
//  biary
//
//  Created by 이창현 on 04/11/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit
import SDWebImage
import ActionSheetPicker_3_0

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
    
    var isMine: Bool {
        return (bookInfo.writerToken == API.currentUser.token)
    }
    
    var sortedContents:[Content] = [Content]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        setNavigationBar()
        tabBarController?.tabBar.isHidden = true;
        headerHeight = UIWindow().screen.bounds.height * 0.4
        sortedContents = contents
        //ratio
        self.setUpHeaderView()
        tableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        sortedContents = contents
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
        
        customNavigationBar.peopleButton.isHidden = !isMine
        
        customNavigationBar.peopleButton.setTitle("공개", for: .normal)
        customNavigationBar.peopleButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)

        customNavigationBar.moreButton.setImage(UIImage(named: "setting"), for: .normal)
        customNavigationBar.backBtnHandler = {
            print("backButton button pressed")
            //self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
        customNavigationBar.moreBtnHandler = {
            let cb = self.bookInfo!
            let actionSheet = UIAlertController(title: cb.title, message: cb.description, preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "공유", style: .default, handler: { _ in
            })
            
            actionSheet.addAction(UIAlertAction(title: "책일기 정렬", style: .default, handler: { _ in
                if let action = ActionSheetStringPicker(title: "책일기 정렬", rows: ["오래된 순","최신 순","페이지 순"]
                    , initialSelection: 0, doneBlock: {
                        picker, indexes, values in
                        
                        
                        let selectedText = values! as! String
                        switch selectedText {
                        case "페이지 순":
                            self.sortedContents = self.contents.filter { $0.title.range(of: " P.") != nil }
                            //191 P. 를 191로 만들고 나서 int로 비교
                            self.sortedContents = self.sortedContents.sorted( by: {
                                guard let title0 = Int($0.title.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else { return false }
                                guard let title1 = Int($1.title.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else { return false }
                                
                                return title0 < title1
                            })
                            break
                        //최신순
                        case "최신 순":
                            self.sortedContents = self.contents.sorted( by: {
                                $0.date > $1.date
                            })
                            break
                            
                        //오래된 순
                        case "오래된 순":
                            self.sortedContents = self.contents.sorted( by: {
                                $0.date < $1.date
                            })
                            break
                        default:
                            self.sortedContents = self.contents
                            break;
                        }
                        return
                }, cancel: { ActionStringCancelBlock in return }, origin: self.customNavigationBar.moreButton) {
                    
                    action.toolbarButtonsColor = UIColor.mainColor
                    action.show()
                }
            }))
            
            //                let image = UIImage(named: "ssss")
            //                actionSheet.setValue(image?.withRenderingMode(.alwaysOriginal), forKey: "image")
            actionSheet.addAction(action)
            actionSheet.addAction(UIAlertAction(title: "편집", style: .default, handler: { _ in
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookCreateVC") as! BookCreateVC
                vc.title = "책 편집하기"
                vc.bookInfo = cb;
                self.present(vc, animated: true, completion: nil)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                let real = UIAlertController(title: "정말 삭제하시겠습니까?", message: "삭제한 책은 복구할 수 없습니다.", preferredStyle: .alert);
                
                real.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
                real.addAction(UIAlertAction(title: "삭제", style: UIAlertAction.Style.destructive, handler: { _ in
                    Book.delete(withToken: cb.token);
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(real, animated: true, completion: nil)
            }))
        
            
            
            actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            
            
            self.present(actionSheet, animated: true, completion: nil)
            
        }
        customNavigationBar.peopleBtnHandler = {
            let a = API.currentBooks[Book.find(withToken: self.bookInfo.token)].isPublic ?? true
            API.currentBooks[Book.find(withToken: self.bookInfo.token)].isPublic = !a
            if (!a == true) {//바꾼 값
                self.customNavigationBar.peopleButton.setTitle("공개", for: .normal)
            } else {
                self.customNavigationBar.peopleButton.setTitle("비공개", for: .normal)
            }
            print(API.currentBooks[Book.find(withToken: self.bookInfo.token)].isPublic)
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
        headerView.date = bookInfo.date ?? Date()
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
        return sortedContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DetailCell
        cell.title = sortedContents[indexPath.row].title
        let attributedString = NSMutableAttributedString(string: sortedContents[indexPath.row].article)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2.5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        cell.contentLabel.attributedText = attributedString
        cell.dateLabel.text = sortedContents[indexPath.row].date.getDate()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WriteVC") as! WriteVC
        vc.bookInfo = self.bookInfo
        vc.contentInfo = self.sortedContents[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (bookInfo.writerToken == API.currentUser.token) {
            if editingStyle == .delete {
                // Delete the row from the data source
                
                for (i,item) in API.currentContents.enumerated() {
                    if item.token == sortedContents[indexPath.row].token {
                        API.currentContents.remove(at: i)
                    }
                }
                // Delete the row from the TableView tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
                
                sortedContents = contents
                tableView.reloadData()
            }
        }
        
    }
}
