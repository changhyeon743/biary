//
//  BookAddSearchVC.swift
//  biary
//
//  Created by 이창현 on 05/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit

class BookAddSearchVC: UIViewController,UITextFieldDelegate,UIViewControllerPreviewingDelegate {
    
    var navigationBar:NavigationBar!
    
    var searchWithBarcodeBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    var result: [Book] = []
    
    var bookCreateVC: BookCreateVC?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        registerForPreviewing(with: self, sourceView: tableView)
        searchField.becomeFirstResponder()
        searchField.delegate = self
        navigationBar = NavigationBar(frame: CGRect.zero, title: "책 검색")
        
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
        searchWithBarcodeBtn.setTitle("바코드로 검색하기", for: .normal)
        searchWithBarcodeBtn.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Bold", size: 15)
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
        navigationBar.setToAnotherNavigation(sub: "Naver Books에서 검색됩니다.")
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchBtn.translatesAutoresizingMaskIntoConstraints = false
        searchField.clearButtonMode = .whileEditing
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: self.searchField.bottomAnchor, constant: 12),
            
            searchField.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 8),
            searchField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24),
            searchField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -64),
            searchField.heightAnchor.constraint(equalToConstant: 48),
    
            
            searchBtn.rightAnchor.constraint(equalTo: searchField.rightAnchor,constant: 40),
            searchBtn.centerYAnchor.constraint(equalTo: searchField.centerYAnchor)
            
            
            ])
        
        tableView.register(UINib(nibName: "BookCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    override func viewDidLayoutSubviews() {
        searchField.addBorderBottom(height: 1, color: UIColor(r: 90, g: 90, b: 90), margin_right: -40)
    }
    
    @objc func barcode(sender: UIButton) {
        let vc = BarcodeScannerVC();
        vc.searchVC = self
        let navigationController = UINavigationController(rootViewController: vc)
        self.navigationController?.pushViewController(navigationController, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return false
    }
    
    
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        search()
    }
    
    func search() {
        API.user.search(query: searchField.text ?? "") { (json) in
            self.result = Book.transformNaverBook(fromJSON: json)
            self.tableView.reloadData()
            self.view.endEditing(true)
        }
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
        if let vc = bookCreateVC {
            let book = result[indexPath.row]
            vc.titleField.text = book.title.withoutHtml
            vc.authorField.text = book.author.withoutHtml
            vc.publisherField.text = book.publisher.withoutHtml
            vc.explainTextView.text = book.description.withoutHtml
            vc.imgLink = book.imageURL
            vc.importedBook = book
        }
        dismiss(animated: true, completion: nil)
    }
    
}
