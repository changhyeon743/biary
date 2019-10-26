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
import SDStateTableView

protocol BookDetailDelegate: class {
    func scrollTo(_ index: Int)
    func scrollToLast()
}

var hasTopNotch: Bool {
    if #available(iOS 11.0, tvOS 11.0, *) {
        // with notch: 44.0 on iPhone X, XS, XS Max, XR.
        // without notch: 24.0 on iPad Pro 12.9" 3rd generation, 20.0 on iPhone 8 on iOS 12+.
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 24
    }
    return false
}


class BookDetailVC: UIViewController , BookDetailDelegate{
    func scrollTo(_ index: Int) {
        tableView.scrollToRow(at: IndexPath(item: index, section: 0) , at: .bottom, animated: true)
    }
    func scrollToLast() {
        tableView.scrollToRow(at: IndexPath(item: contents.count-1, section: 0) , at: .bottom, animated: true)
    }
    
    
    var customNavigationBar: DetailNavigationBar!
    
    @IBOutlet weak var tableView:SDStateTableView!

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
                return API.currentShowingFriend?.contents.filter{$0.bookToken == self.bookInfo.token} ?? []
            }
        }
    }
    
    @IBOutlet weak var addBtn: UIButton!
    
    var isMine: Bool {
        return (bookInfo.writerToken == API.currentUser.token)
    }
    
    var sortedContents:[Content] = [Content]() {
        didSet {
            if (self.sortedContents.count == 0) {
                if (isMine) {
                    self.tableView.setState(.withImage(image: nil, title: "글이 없습니다", message: "우측 하단의 버튼을 눌러 책일기를 써보세요"))
                } else {
                    
                    self.tableView.setState(.withImage(image: nil, title: "글이 없습니다", message: ""))
                }
                
            } else {
                self.tableView.setState(.dataAvailable)
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        //
        setNavigationBar()
        headerHeight = UIWindow().screen.bounds.height * 0.4
        //여기
        sortedContents = contents
        //ratio
        self.setUpHeaderView()
        tableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.allowsSelection = isMine
        tableView.stateViewCenterPositionOffset = CGPoint(x: 0, y: -148)

    }
    override func viewDidAppear(_ animated: Bool) {
        if (self.bookInfo.writerToken != API.currentUser.token) {
            addBtn.isHidden = true
        }
        sortedContents = contents
        tableView.reloadData()
        //tabBarController?.tabBar.isTranslucent = true;

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //tabBarController?.tabBar.isTranslucent = false;

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
        writeVC.detailDelegate = self
        writeVC.bookInfo = self.bookInfo
    }
    
    func setNavigationBar() {
        customNavigationBar = DetailNavigationBar(frame: CGRect.zero)
        
        self.view.addSubview(customNavigationBar)
        
        customNavigationBar.titleLabel.text = bookInfo.title
        customNavigationBar.peopleButton.isHidden = !isMine
        
        if (bookInfo.writerToken == API.currentUser.token) {
            if (API.currentBooks[Book.find(withToken: self.bookInfo.token)].isPublic ?? true) {//바꾼 값
                self.customNavigationBar.peopleButton.setTitle("공개".localized, for: .normal)
            } else {
                self.customNavigationBar.peopleButton.setTitle("비공개".localized, for: .normal)
            }
        }
        
        customNavigationBar.peopleButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)// UIFont(name: "NotoSansCJKkr-Regular", size: 15)

        customNavigationBar.moreButton.setImage(UIImage(named: "setting"), for: .normal)
        customNavigationBar.backBtnHandler = {
            //print("backButton button pressed")
            //self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
        customNavigationBar.moreBtnHandler = {
            
            let cb = self.bookInfo!
            let actionSheet = UIAlertController(title: cb.title, message: cb.description, preferredStyle: .actionSheet)
            actionSheet.popoverPresentationController?.sourceView = self.customNavigationBar.moreButton
            let action = UIAlertAction(title: "공유".localized, style: .default, handler: { _ in
                // text to share
                let content = self.contents.map{$0.title+"\n"+$0.article}.joined(separator:"\n")
                let text = self.bookInfo.title + "\n"+self.bookInfo.author + " . " + self.bookInfo.publisher+"\n\n"+content+"\n\nBiary - 책 읽고 책일기"
                
                // set up activity view controller
                let textToShare = [ text ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                
                // present the view controller
                self.present(activityViewController, animated: true, completion: nil)
            })
            
            actionSheet.addAction(UIAlertAction(title: "책일기 정렬".localized, style: .default, handler: { _ in
                if let action = ActionSheetStringPicker(title: "책일기 정렬".localized, rows: ["오래된 순".localized,"최신 순".localized,"페이지 순".localized,"책의 시작".localized,"생각".localized,"좋은 점".localized,"나쁜 점".localized,"문장".localized,"무제".localized]
                    , initialSelection: 0, doneBlock: {
                        picker, indexes, values in
                        
                        
                        let selectedText = values! as! String
                        switch selectedText {
                        case "페이지 순".localized:
                            self.sortedContents = self.contents.filter { $0.title.range(of: " P.") != nil }
                            self.sortedContents = self.sortedContents + (self.contents.filter { $0.title.range(of: " 페이지") != nil})
                            
                            //191 P. 를 191로 만들고 나서 int로 비교
                            self.sortedContents = self.sortedContents.sorted( by: {
                                guard let title0 = Int($0.title.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else { return false }
                                guard let title1 = Int($1.title.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else { return false }
                                
                                return title0 < title1
                            })
                            break
                        //최신순
                        case "최신 순".localized:
                            self.sortedContents = self.contents.sorted( by: {
                                $0.date > $1.date
                            })
                            break
                            
                        //오래된 순
                        case "오래된 순".localized:
                            self.sortedContents = self.contents.sorted( by: {
                                $0.date < $1.date
                            })
                            break
                        default:
                            self.sortedContents = self.contents.filter { $0.title ==
                                selectedText }
                            break;
                        }
                        return
                }, cancel: { ActionStringCancelBlock in return }, origin: self.customNavigationBar.moreButton) {
                    
                    if #available(iOS 13.0, *) {
                        action.pickerBackgroundColor = .systemGray5
                        action.setTextColor(.label)
                    } else {
                        // Fallback on earlier versions
                    }
                    action.toolbarButtonsColor = UIColor.mainColor
                    action.show()
                }
            }))
            
            //                let image = UIImage(named: "ssss")
            //                actionSheet.setValue(image?.withRenderingMode(.alwaysOriginal), forKey: "image")
            actionSheet.addAction(action)
            
            if (self.bookInfo.writerToken == API.currentUser.token) {
                actionSheet.addAction(UIAlertAction(title: "편집".localized, style: .default, handler: { _ in
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookCreateVC") as! BookCreateVC
                    vc.bookDetailVC = self
                    vc.title = "책 편집하기".localized
                    vc.bookInfo = cb;
                    self.present(vc, animated: true, completion: nil)
                }))
                
                actionSheet.addAction(UIAlertAction(title: "삭제".localized, style: .destructive, handler: { _ in
                    let real = UIAlertController(title: "정말 삭제하시겠습니까?".localized, message: "삭제한 책은 복구할 수 없습니다.".localized, preferredStyle: .alert);
                    
                    real.addAction(UIAlertAction(title: "취소".localized, style: .default, handler: nil))
                    real.addAction(UIAlertAction(title: "삭제".localized, style: UIAlertAction.Style.destructive, handler: { _ in
                        Book.remove(withToken: cb.token);
                        self.navigationController?.popViewController(animated: true)
                        //self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(real, animated: true, completion: nil)
                }))
            }
            
        
            
            
            actionSheet.addAction(UIAlertAction(title: "취소".localized, style: .cancel, handler: nil))
            
            
            self.present(actionSheet, animated: true, completion: nil)
            
        }
        customNavigationBar.peopleBtnHandler = {
            
            let a = API.currentBooks[Book.find(withToken: self.bookInfo.token)].isPublic ?? true
            
            API.currentBooks[Book.find(withToken: self.bookInfo.token)].isPublic = !a
            if (!a == true) {//바꾼 값
                self.customNavigationBar.peopleButton.setTitle("공개".localized, for: .normal)
            } else {
                self.customNavigationBar.peopleButton.setTitle("비공개".localized, for: .normal)
            }
            API.user.update()
            //print(API.currentBooks[Book.find(withToken: self.bookInfo.token)].isPublic)
        }
        

        
        if (hasTopNotch) {
            NSLayoutConstraint.activate([
                customNavigationBar.topAnchor.constraint(equalTo: self.view.topAnchor),
                customNavigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                customNavigationBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                customNavigationBar.heightAnchor.constraint(equalToConstant: 96)
            ])
        } else {
            NSLayoutConstraint.activate([
                customNavigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                customNavigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                customNavigationBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                customNavigationBar.heightAnchor.constraint(equalToConstant: 64)
            ])
            
        }
    }
    
    
    
    func setUpHeaderView() {
        if #available(iOS 13.0, *) {
            tableView.backgroundColor = UIColor.systemBackground
        } else {
            // Fallback on earlier versions
            tableView.backgroundColor = UIColor.white
        }
        headerView = tableView.tableHeaderView as? DetailHeaderView
        headerView.setUpView()
        headerView.title = bookInfo.title
        headerView.subTitle = bookInfo.author + " . " + bookInfo.publisher
        headerView.author = bookInfo.writerName
        headerView.date = bookInfo.date ?? Date()
        print("image",bookInfo.imageURL)
        headerView.imageView.sd_setImage(with: URL(string: bookInfo.imageURL), completed: nil)
        
        tableView.tableHeaderView = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.addSubview(headerView)
        
        newHeaderLayer = CAShapeLayer()
        newHeaderLayer.fillColor = UIColor.black.cgColor
        headerView.layer.mask = newHeaderLayer
        
        let newheight = headerHeight
        tableView.contentInset = UIEdgeInsets(top: newheight, left: 0, bottom: 64, right: 0)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (bookInfo.writerToken == API.currentUser.token) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WriteVC") as! WriteVC
            vc.bookInfo = self.bookInfo
            vc.contentInfo = self.sortedContents[indexPath.row]
            self.present(vc, animated: true, completion: nil)
        }
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
