//
//  BookAddSearchVC.swift
//  biary
//
//  Created by 이창현 on 05/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit
import AMPopTip

class BookAddSearchVC: UIViewController,UITextFieldDelegate,UIViewControllerPreviewingDelegate {
    var mainVC: MainVC?
    var navigationBar:NavigationBar!
    
    var searchWithBarcodeBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    var result: [Book] = []
    
    var bookCreateVC: BookCreateVC?
    
    var indicator: IndicatorView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        indicator = IndicatorView(uiView: self.view)
        registerForPreviewing(with: self, sourceView: tableView)
        searchField.becomeFirstResponder()
        searchField.delegate = self
        navigationBar = NavigationBar(frame: CGRect.zero, title: "책 검색".localized)
        
        navigationBar.settingBtnHandler = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "bookshelf") as! BookShelfVC
            self.present(vc, animated: true, completion: nil)
            //self.performSegue(withIdentifier: "bookshelfSegue", sender: nil)
        }
        navigationBar.closeBtnHandler = {
            self.dismiss(animated: true, completion: nil)
        }
        
        
        self.view.addSubview(navigationBar)
        searchWithBarcodeBtn = UIButton()
        searchWithBarcodeBtn.setTitle("바코드로 검색하기".localized, for: .normal)
        searchWithBarcodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15,weight: .bold)//UIFont(name: "NotoSansCJKkr-Bold", size: 15)
        searchWithBarcodeBtn.setTitleColor(UIColor.mainColor, for: .normal)
        searchWithBarcodeBtn.addTarget(self, action: #selector(barcode(sender:)), for: .touchUpInside)
        
        self.view.addSubview(searchWithBarcodeBtn)
        searchWithBarcodeBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 130),
            searchWithBarcodeBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            searchWithBarcodeBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 12)
            ])
        navigationBar.setConstraints()
        navigationBar.setToAnotherNavigation(sub: "Naver Books에서 검색됩니다.".localized)
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchBtn.translatesAutoresizingMaskIntoConstraints = false
        searchField.clearButtonMode = .whileEditing
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: self.searchField.bottomAnchor, constant: 12),
            
            searchField.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 8),
            searchField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24),
            searchField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -64),
            searchField.heightAnchor.constraint(equalToConstant: 48),
    
            
            searchBtn.rightAnchor.constraint(equalTo: searchField.rightAnchor,constant: 40),
            searchBtn.centerYAnchor.constraint(equalTo: searchField.centerYAnchor)
            
            
            ])
        
        tableView.register(UINib(nibName: "BookCell", bundle: nil), forCellReuseIdentifier: "cell")
        
//        if (API.currentBooks.count < 2) {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.pop.shouldDismissOnTap = true
//                self.pop.bubbleColor = UIColor.mainColor
//                self.pop.padding = 10
//                self.pop.offset = 5
//                self.pop.show(text: "검색하고자 하고자 하는 책의 제목을 입력해주세요.", direction: .up , maxWidth: 200, in: self.view, from: self.searchField.frame)
//            }
//        }
    }
//    let pop = PopTip()
    
    override func viewDidLayoutSubviews() {
        searchField.addBorderBottom(height: 1, color: UIColor(r: 90, g: 90, b: 90), margin_right: -40)
    }
    
    @objc func barcode(sender: UIButton) {
        print("")
        let vc = BarcodeScannerVC();
        vc.searchVC = self
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil) 
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return false
    }
    
    
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        search()
    }
    
    func search() {
        indicator?.start()
        let pre = Locale.preferredLanguages[0]
        if ( pre == "ko-KR") {
            API.user.search(query: searchField.text ?? "") { (json) in
                self.result = Book.transformNaverBook(fromJSON: json)
                self.searchEnded()
            }
        } else {
            API.user.searchInGoogle(query: searchField.text ?? "") { (json) in
                self.result = Book.transformGoogleBook(fromJSON: json)
                self.searchEnded()
            }
        }
        
    }
    
    func searchEnded() {
        self.indicator?.stop()
        self.tableView.reloadData()
        
        if (self.result.count == 1) {
            guard let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) else {return}
            cell.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1)
            UIView.animate(withDuration: 0.2, animations: {
                cell.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1)
            },completion: { finished in
                UIView.animate(withDuration: 0.2, animations: {
                    cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
                })
            })
        } else if (self.result.count == 0) {
            self.toast(text: "검색 결과가 없습니다.".localized)
        }
        
        self.view.endEditing(true)
    }

    func previewVC(for index:Int) -> PreviewVC {
        let vc = UINib(nibName: "Preview", bundle: nil).instantiate(withOwner: nil, options: nil).first as! PreviewVC
        
        //vc.~~
        let book = result[index];
        
        vc.preferredContentSize = CGSize(width: 360, height: 360)
        vc.titleLbl.text = book.title.withoutHtml
        vc.subTitle = book.author.withoutHtml + " . " + book.publisher.withoutHtml
        vc.explain = book.description.withoutHtml
        vc.imgLink = book.imageURL
        return vc
    }
 
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRow(at: location) {
            previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
            //previewingContext.sourceRect = CGRect(x: 0, y: 0, width: 240, height: 100)
            return previewVC(for: indexPath.row)
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        //dismiss(animated: true, completion: nil)
    }
}


extension BookAddSearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BookCell
        let book = result[indexPath.row];
        cell.titleLbl.text = book.title.withoutHtml
        cell.subTitle = book.author.withoutHtml + " . " + book.publisher.withoutHtml
        cell.explain = book.description.withoutHtml
        cell.imgLink = book.imageURL
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "BookCreateVC") as! BookCreateVC
//        print("1010",vc)
        //if let vc = bookCreateVC {
//            let book = result[indexPath.row]
//            vc.titleField.text = book.title.withoutHtml
//            vc.authorField.text = book.author.withoutHtml
//            vc.publisherField.text = book.publisher.withoutHtml
//            vc.explainTextView.text = book.description.withoutHtml
//            vc.imgLink = book.imageURL
//            vc.importedBook = book
        //}
        vc.mainVC = mainVC
        present(vc, animated: true) {
            vc.setText(book: self.result[indexPath.row])
        }
    }
    
}

extension BookAddSearchVC {
    func toast(text: String) {
        let toastLabel: UILabel = UILabel(frame: CGRect(x: view.frame.size.width / 2 - 150, y: view.frame.size.height - 150, width: 300, height: 30))
        toastLabel.backgroundColor = UIColor(r: 30, g: 30, b: 30,alpha: 0.65)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center
        view.addSubview(toastLabel)
        
        toastLabel.text = text
        toastLabel.font = UIFont.boldSystemFont(ofSize: 15)
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 9
        toastLabel.clipsToBounds = true
        UIView.animate(withDuration: 1.6, animations: {
            toastLabel.layer.cornerRadius = 10
        }) { (isBool) in
            UIView.animate(withDuration: 0.5, animations: {
                toastLabel.alpha = 0.0
            }, completion: {
                (isBool) -> Void in
                self.view.willRemoveSubview(toastLabel)
                //toastLabel.dismiss(animated: true, completion: nil)
            })
        }
        
    }
}
