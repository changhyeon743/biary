//
//  BookShelfVC.swift
//  biary
//
//  Created by 이창현 on 26/02/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit

class BookShelfVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editBtn: UIButton!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return API.currentUser.bookShelf.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = API.currentUser!.bookShelf[indexPath.row].title
        
        return cell;
    }

    @IBOutlet weak var subTitleLbl: UILabel!
    
    var mainVCDelegate: MainVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0);
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        subTitleLbl.text = "총 ".localized+String(API.currentUser.bookShelf.count)+"개의 책장이 있습니다.".localized
    }

    @IBAction func addBtnPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "책장 추가".localized, message: nil, preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "새로 추가할 책장의 이름을 입력하세요.".localized
        }
        let confirmAction = UIAlertAction(title: "확인".localized, style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            if (textField.text?.isEmpty == false) {
                if (API.currentUser.bookShelf.filter{$0.title == textField.text ?? ""}.count <= 0) { //겹치는게 없을 경우
                    Bookshelf.append(title: textField.text ?? "")
                }
            }
            
            self.tableView.reloadData()
            //compare the current password and do action here
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "취소".localized, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func editBtnPressed(_ sender: UIButton) {
        if(self.tableView.isEditing == true) {
            self.tableView.isEditing = false
            editBtn.setTitle("편집".localized, for: .normal)
        }
        else {
            self.tableView.isEditing = true
            editBtn.setTitle("완료".localized, for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        mainVCDelegate?.refresh()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if (API.currentUser.bookShelf[indexPath.row].books.count>0) {
                
                var bookTokens = [String]()
                var bookNames = [String]()
                for i in API.currentUser.bookShelf[indexPath.row].books {
                    //print(API.currentBooks[Book.find(withToken: i)].title, Bookshelf.getCount(bookToken: i))
                    if (Bookshelf.getCount(bookToken: i) == 1) { //모든 책장 중 자기 책장에만 있으면 안됨
                        bookTokens.append(API.currentBooks[Book.find(withToken: i)].token)
                        bookNames.append(API.currentBooks[Book.find(withToken: i)].title)
                    }
                }
                
                let msg = (bookTokens.count > 0 ? "계속하면 ".localized+bookNames.joined(separator: ", ")+"도 사라지게 됩니다.".localized : nil)
                let alert = UIAlertController(title: "책장을 삭제합니다".localized,message: msg, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "계속".localized, style: UIAlertAction.Style.destructive, handler: {_ in
                    API.currentUser.bookShelf.remove(at: indexPath.row)
                    for i in bookTokens {
                        Book.remove(withToken: i)
                    }
                    tableView.reloadData()
                }))
                alert.addAction(UIAlertAction(title: "취소".localized, style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                API.currentUser.bookShelf.remove(at: indexPath.row)
                
                API.user.update { (json) in
                    
                }
            }
            
            
            mainVCDelegate?.refresh()

            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        let rowToMove = API.currentUser.bookShelf[fromIndexPath.row]
        API.currentUser.bookShelf.remove(at: fromIndexPath.row)
        API.currentUser.bookShelf.insert(rowToMove, at: toIndexPath.row)
        
        API.user.update { (json) in
            //print(json)
        }
        mainVCDelegate?.refresh()

        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(tableView.isEditing)
        if tableView.isEditing {
            let alertController = UIAlertController(title: "책장 이름 변경".localized, message: nil, preferredStyle: .alert)
            alertController.addTextField { (textfield) in
                textfield.text = API.currentUser.bookShelf[indexPath.row].title
            }
            let confirmAction = UIAlertAction(title: "확인".localized, style: .default) { [weak alertController] _ in
                guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
                if (textField.text?.isEmpty == false) {
                    API.currentUser.bookShelf[indexPath.row].title = textField.text ?? ""
                }
                self.mainVCDelegate?.refresh()

                self.tableView.reloadData()
                //compare the current password and do action here
            }
            alertController.addAction(confirmAction)
            alertController.addAction(UIAlertAction(title: "취소".localized, style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
}
