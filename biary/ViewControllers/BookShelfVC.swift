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

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0);
        

        // Do any additional setup after loading the view.
    }

    @IBAction func addBtnPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "책장 추가", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "새로 추가할 책장의 이름을 입력하세요."
        }
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak alertController] _ in
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
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
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
            editBtn.setTitle("편집", for: .normal)
        }
        else {
            self.tableView.isEditing = true
            editBtn.setTitle("완료", for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            API.currentUser.bookShelf.remove(at: indexPath.row)
            // Delete the row from the TableView tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            API.user.update { (json) in
                //
            }
            
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
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
