//
//  BookCreateVC.swift
//  biary
//
//  Created by 이창현 on 08/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit
import SDWebImage
import Spring
import AMPopTip

class BookCreateVC: UIViewController {
    @IBOutlet weak var titleField: SpringTextField!
    @IBOutlet weak var authorField: SpringTextField!
    @IBOutlet weak var publisherField: SpringTextField!
    
    @IBOutlet weak var explainTextView: SpringTextView!
    
    @IBOutlet weak var bookShelfsBtn: SpringButton!
    
    @IBOutlet weak var bookImageView: SpringImageView!
    
//    @IBOutlet weak var importBtn: UIButton!
    var navigationBar:NavigationBar!
    
    
    var bookTitle = "무제"{
        didSet {
            titleField.text = bookTitle;
        }
    }
    
    var bookInfo:Book?
    
    
    
    var imgLink = "" {
        didSet {
            bookImageView.sd_setImage(with: URL(string: imgLink), completed: nil)
            //bookImageView.image = UIImage(named: "ssss")
            //bookImageView.sd_setImage(with: URL(string: "https://us.123rf.com/450wm/kchung/kchung1612/kchung161200233/67624400-3d-rendering-book-mockup-top-view-of-blank-hardcover-book-design-isolated-on-white-background.jpg?ver=6"), completed: nil)
        }
    }
    
    var bookshelfs:[Bookshelf] = [] {
        didSet {
            let str = bookshelfs.map{$0.title}.joined(separator: ", ")
            if (str.isEmpty) {
                bookShelfsBtn.setTitle("눌러서 책장을 선택하세요.", for: .normal)
            } else {
                bookShelfsBtn.setTitle(str, for: .normal)
            }
            
        }
    }
    
    var doneBtn = UIButton()
    
    var importedBook: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.becomeFirstResponder()
        explainTextView.textContainerInset = UIEdgeInsets.zero
        explainTextView.textContainer.lineFragmentPadding = 0
        explainTextView.placeholder = "설명"
        
        
        navigationBar = NavigationBar(frame: CGRect.zero, title: "책 추가하기")
        if title != nil {
            navigationBar.titleLbl.text = title!
        }
        
        navigationBar.settingBtnHandler = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "bookshelf") as! BookShelfVC
            self.present(vc, animated: true, completion: nil)
            //self.performSegue(withIdentifier: "bookshelfSegue", sender: nil)
        }
        navigationBar.closeBtnHandler = {
            self.dismiss(animated: true, completion: nil)
        }
        
        
        self.view.addSubview(navigationBar)
        doneBtn = UIButton()
        doneBtn.setTitle("완료", for: .normal)
        doneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15,weight: .bold)//UIFont(name: "NotoSansCJKkr-Bold", size: 15)
        doneBtn.setTitleColor(UIColor.mainColor, for: .normal)
        doneBtn.addTarget(self, action: #selector(doneBtnPressed(_:)), for: .touchUpInside)
        
        self.view.addSubview(doneBtn)
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 130),
            doneBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            doneBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 12)
            ])
        navigationBar.setConstraints()
        navigationBar.setToAnotherNavigation(sub: "아래에 있는 텍스트를 눌러 정보를 수정할 수 있습니다.")
        
        setBookInfos()
//        if (API.currentBooks.count < 2) {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.pop.shouldDismissOnTap = true
//                self.pop.bubbleColor = UIColor.mainColor
//                self.pop.padding = 10
//                self.pop.offset = 5
//                self.pop.show(text: "눌러서 책을 검색하세요", direction: .up , maxWidth: 200, in: self.view, from: self.importBtn.frame)
//            }
//        }
        
    }
    
    let pop = PopTip()
    var bookDetailVC:BookDetailVC?
    
    func setBookInfos() {
        if let book = bookInfo { //수정중일경우
            self.titleField.text = book.title
            self.authorField.text = book.author
            self.publisherField.text = book.publisher
            self.explainTextView.text = book.description
            self.bookshelfs = API.currentUser.bookShelf.filter{for i in $0.books {
                if (i==book.token) {
                    return true
                }}
                return false
            }
            self.imgLink = book.imageURL
            self.importedBook = book
        }
    }
    
    @objc func doneBtnPressed(_ sender: Any) {
        guard let title = titleField.text?.withoutHtml, !title.isEmpty else {
            self.titleField.animation = "shake"
            self.titleField.force = 0.5
            self.titleField.animate()
            return
        }
        guard let author = authorField.text?.withoutHtml, !author.isEmpty else {
            self.authorField.animation = "shake"
            self.authorField.force = 0.5
            self.authorField.animate()
            return
        }
        guard let publisher = publisherField.text?.withoutHtml, !publisher.isEmpty else {
            self.publisherField.animation = "shake"
            self.publisherField.force = 0.5
            self.publisherField.animate()
            return
        }
        guard let explain = explainTextView.text, !explain.isEmpty else {
            self.explainTextView.animation = "shake"
            self.explainTextView.force = 0.5
            self.explainTextView.animate()
            return
        }
        let isbn = importedBook?.isbn ?? ""
        var imageLink = importedBook?.imageURL ?? ""
        imageLink = imageLink.components(separatedBy: "?")[0]
        if (bookshelfs.count == 0) {
            self.bookShelfsBtn.animation = "shake"
            self.bookShelfsBtn.force = 0.5
            self.bookShelfsBtn .animate()
            return
        }
        
        //bookImageView.image = imageWith(name: title)
        if (bookInfo == nil) {
            Book.append(title: title, author: author, publisher: publisher, isbn: isbn.withoutHtml, imageURL: imageLink, description: explain.withoutHtml, bookshelfs: bookshelfs)
        } else if let book = bookInfo { //수정 중 일경우
            Bookshelf.clean(bookToken: book.token)
            Bookshelf.addBook(at: bookshelfs, bookToken: book.token)
            Book.edit(title: title, author: author, publisher: publisher, isbn: isbn.withoutHtml, imageURL: imageLink, description: explain.withoutHtml, bookshelfs: bookshelfs, isPublic: true, bookToken: book.token)
            bookDetailVC?.headerView.title = title
            bookDetailVC?.headerView.subTitle = author + " . " + publisher
            bookDetailVC?.headerView.author = author
            bookDetailVC?.tableView.reloadData()
        }
        API.user.update { (json) in
            
        }
        
        
        //API.data.saveBooks()
        if let rootvc = self.view.window?.rootViewController {
            print("rootVC: ",rootvc)
            rootvc.dismiss(animated: true, completion: nil)
            
        }
        //dismiss(animated: true, completion: nil)
    }
    
    func setText(book: Book) {
        titleField.text = book.title.withoutHtml
        authorField.text = book.author.withoutHtml
        publisherField.text = book.publisher.withoutHtml
        explainTextView.text = book.description.withoutHtml
        imgLink = book.imageURL
        importedBook = book
    }
    
    
//    @IBAction func importBtnPressed(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "BookAddSearchVC") as! BookAddSearchVC
//
//        vc.bookCreateVC = self
//        present(vc, animated: true, completion: nil)
//    }
    
    @IBAction func bookshelfBtnPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "BookShelfSelectingVC") as! BookShelfSelectingVC
        vc.bookCreateVC = self
        
        present(vc, animated: true, completion: nil)
        
    }
    
    
}
