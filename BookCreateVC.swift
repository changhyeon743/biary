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

class BookCreateVC: UIViewController,UITextViewDelegate {
    @IBOutlet weak var titleField: SpringTextField!
    @IBOutlet weak var authorField: SpringTextField!
    @IBOutlet weak var publisherField: SpringTextField!
    
    @IBOutlet weak var explainTextView: SpringTextView!
    
    @IBOutlet weak var bookShelfsBtn: SpringButton!
    
    @IBOutlet weak var bookImageView: SpringImageView!
    
    var navigationBar:NavigationBar!
    
    
    var bookTitle = "무제"{
        didSet {
            titleField.text = bookTitle;
        }
    }
    
    
    
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
        
        explainTextView.text = "설명"
        explainTextView.textColor = UIColor.lightGray
        explainTextView.delegate = self
        
        
        explainTextView.textContainerInset = UIEdgeInsets.zero
        explainTextView.textContainer.lineFragmentPadding = 0
        
        navigationBar = NavigationBar(frame: CGRect.zero, title: "책 추가하기")
        
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
        doneBtn.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Bold", size: 15)
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
        
        
    }
    
    @objc func doneBtnPressed(_ sender: Any) {
        guard let title = titleField.text, !title.isEmpty else {
            self.titleField.animation = "shake"
            self.titleField.force = 0.5
            self.titleField.animate()
            return
        }
        guard let author = authorField.text, !author.isEmpty else {
            self.authorField.animation = "shake"
            self.authorField.force = 0.5
            self.authorField.animate()
            return
        }
        guard let publisher = publisherField.text, !publisher.isEmpty else {
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
        if (bookshelfs.count == 0) {
            self.bookShelfsBtn.animation = "shake"
            self.bookShelfsBtn.force = 0.5
            self.bookShelfsBtn .animate()
            return
        }
        
        //bookImageView.image = imageWith(name: title)
        if let book = importedBook {
            Book.append(title: book.title, author: book.author, publisher: book.publisher, isbn: book.isbn, imageURL: book.imageURL, description: book.description, bookshelfs: bookshelfs)
        } else {
            Book.append(title: title, author: author, publisher: publisher, isbn: "", imageURL: "", description: description, bookshelfs: bookshelfs)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func importBtnPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "BookAddSearchVC") as! BookAddSearchVC
        
        vc.bookCreateVC = self
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func bookshelfBtnPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "BookShelfSelectingVC") as! BookShelfSelectingVC
        vc.bookCreateVC = self
        
        present(vc, animated: true, completion: nil)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "설명"
            textView.textColor = UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
        }
    }
    
}
