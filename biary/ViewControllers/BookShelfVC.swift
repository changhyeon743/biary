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

    @IBAction func closeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func editBtnPressed(_ sender: Any) {
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
            
            API.User.update { (json) in
                print(json)
            }
            
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        let rowToMove = API.currentUser.bookShelf[fromIndexPath.row]
        API.currentUser.bookShelf.remove(at: fromIndexPath.row)
        API.currentUser.bookShelf.insert(rowToMove, at: toIndexPath.row)
        
        API.User.update { (json) in
            print(json)
        }
        
        tableView.reloadData()
    }
    
}
