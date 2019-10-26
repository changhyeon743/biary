//
//  ExploreVC.swift
//  
//
//  Created by 이창현 on 05/08/2019.
//

import Foundation
import UIKit
import ActionSheetPicker_3_0
import SDWebImage

protocol ExploreDelegate {
    func sendViewToBack(view: BookView)
    func sendAlert(alert: UIAlertController)
    func show(bookInfo: Book)
    func search(bookInfo: Book)
}

extension ExploreVC: ExploreDelegate {
    func search(bookInfo: Book) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookAddSearchVC") as! BookAddSearchVC
        self.present(vc, animated: true) {
            vc.searchField.text = bookInfo.isbn
            vc.search()
        }
        
    }
    
    func sendAlert(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func sendViewToBack(view: BookView) {
        guard let text = categoryBtn.titleLabel?.text else {return}
        
        getRandomBook(query: text) { (book) in
            guard let b = book else { self.sendViewToBack(view: view); return;}
            if (b.isPublic == true) {
                self.bookList.append(b)
                view.bookInfo = self.bookList[self.currentIndex]
                self.currentIndex += 1
            } else {
                self.sendViewToBack(view: view)
            }
        }
        self.view.sendSubviewToBack(view)
        //guard let url2 = API.currentBooks.randomElement() else {return}
    }
    
    func sendViewToFront(view: BookView,book: Book) {
        view.bookInfo = book
        self.view.bringSubviewToFront(view)
        //guard let url2 = API.currentBooks.randomElement() else {return}
    }
    
    func show(bookInfo: Book) {
        indicator?.start()
        API.book.getContent(ofToken: bookInfo.token) { (json) in
            self.indicator?.stop()
            API.currentShowingFriend = Info(user: nil, books: [], contents: Content.transformContent(fromJSON: json))
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookDetailVC") as! BookDetailVC
            vc.bookInfo = bookInfo
            vc.bookInfo.writerName = "아무개씨".localized
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension ExploreVC {
    func getRandomBook(query:String,completion:@escaping (Book?)->Void) {
        API.user.getRandomBook(query: query, completion: { (json) in
            if (json.isEmpty) {
                completion(nil)
            } else {
                completion(Book.transformBook(fromJSON: json))
            }
        })
    }
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

class ExploreVC: UIViewController {
    var indicator : IndicatorView?

    var navigationBar:NavigationBar!
    
    var bookImageView: BookView!
    var bookImageView2: BookView!
    
    var bookList: [Book] = []
    var currentIndex = 0;
    
    @IBOutlet weak var categoryBtn: UIButton!
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
        indicator = IndicatorView(uiView: self.view)
        categoryBtn.setTitle(Category.RANDOM.rawValue.localized, for: .normal)
        
        navigationBar = NavigationBar(frame: CGRect.zero, title: "탐험".localized)
        bookImageView = BookView(frame: CGRect.zero, image: UIImage(named: "more")!)
        bookImageView2 = BookView(frame: CGRect.zero, image: UIImage(named: "more")!)
        bookImageView.exploreDelegate = self
        bookImageView2.exploreDelegate = self
        
        
        navigationBar.settingBtn.isHidden = true
        navigationBar.settingBtn.setImage(UIImage(named: "undo"), for: .normal)
        navigationBar.settingBtnHandler = {
            
            if (self.bookList.count > 2) {
                //print(self.bookList.debugDescription)
                //self.bookList.removeLast()
                self.currentIndex -= 1

                self.sendViewToFront(view: self.bookImageView, book: self.bookList[self.currentIndex])
            }
            
        }
        
        navigationBar.line.isHidden = false
        navigationBar.addBtn.isHidden = true
        navigationBar.searchBtn.isHidden = true
        self.view.addSubview(navigationBar)
        
        self.view.addSubview(bookImageView)
        self.view.addSubview(bookImageView2)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        bookImageView.translatesAutoresizingMaskIntoConstraints = false
        bookImageView2.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.setConstraints()
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 80),
            
            bookImageView.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor),
            bookImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bookImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bookImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            bookImageView2.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor),
            bookImageView2.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bookImageView2.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bookImageView2.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            ])
    
        sendViewToBack(view: bookImageView)
        sendViewToBack(view: bookImageView2)
    }
    
    enum Category: String {
        
        case RANDOM = "무작위 책"
        case WRITTEN_RANDOM = "글이 있는 무작위 책"
        case TITLE = "다음 제목과 일치"
        case AUTHOR = "다음 작가와 일치"
        case PUBLISHER = "다음 출판사와 일치"
    }
    
    @IBAction func categoryBtnPressed(_ sender: UIButton) {
        
        let categories:[String] = [Category.RANDOM.rawValue.localized, Category.WRITTEN_RANDOM.rawValue.localized, Category.TITLE.rawValue.localized, Category.AUTHOR.rawValue.localized, Category.PUBLISHER.rawValue.localized]
            
        guard let current = sender.title(for: .normal) else {return}
        let inital = categories.firstIndex(of: current)
            
        guard let action = ActionSheetStringPicker(title: "골라서 탐험하기".localized,
                                                 rows: categories,
                                                 initialSelection: inital ?? 0,
                doneBlock: { (picker, index, value) in
                    var rows:[String] = []
                    var formative = ""
                    switch categories[index] {
                    case Category.AUTHOR.rawValue.localized:
                        rows = API.currentBooks.map{$0.author}
                        formative = "작가:".localized
                        break
                    case Category.TITLE.rawValue.localized:
                        rows = API.currentBooks.map{$0.title}
                        formative = "제목:".localized
                        break
                    case Category.PUBLISHER.rawValue.localized:
                        rows = API.currentBooks.map{$0.publisher}
                        formative = "출판사:".localized
                        break
                    default:
                        break
                    }
                    
                    if (categories[index] == Category.AUTHOR.rawValue.localized || categories[index] == Category.PUBLISHER.rawValue.localized || categories[index] == Category.TITLE.rawValue.localized) {
                        let alert = UIAlertController(title: categories[index], message: nil, preferredStyle: .alert)
                        alert.addTextField(configurationHandler: { (textfield) in
                            textfield.placeholder = "입력해주세요.".localized
                        })
                        alert.addAction(UIAlertAction(title: "확인".localized, style: .default, handler: { _ in
                            guard let text = alert.textFields?[0].text else {return}
                            sender.setTitle(formative + text, for: .normal)
                        }))
                        alert.addAction(UIAlertAction(title: "내 책장에서 찾기".localized, style: .default, handler: { _ in
                            
                            
                            guard let action2 = ActionSheetStringPicker(title: categories[index], rows: rows, initialSelection: 0, doneBlock: { (picker, index, value) in
                                guard let picked = value as? String else {return}
                                sender.setTitle(formative+picked, for: .normal)
                            }, cancel: { (picker) in
                                return
                            }, origin: sender) else {return}
                            
                            if #available(iOS 13.0, *) {
                                action2.pickerBackgroundColor = .systemGray5
                                action2.setTextColor(.label)
                                action2.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.label ]

                            } else {
                                // Fallback on earlier versions
                            }
                            action2.toolbarButtonsColor = .mainColor
                            action2.show()
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        sender.setTitle(categories[index], for: .normal)
                    }
                
            }, cancel: { (picker) in
                return
            }, origin: sender) else {return}
        if #available(iOS 13.0, *) {
            action.pickerBackgroundColor = .systemGray5
            action.setTextColor(.label)
            action.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.label ]
        } else {
            // Fallback on earlier versions
        }
        
        action.toolbarButtonsColor = .mainColor
        action.show()
        
    }
}
