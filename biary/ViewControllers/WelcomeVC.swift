//
//  WelcomeVC.swift
//  biary
//
//  Created by 이창현 on 25/02/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        API.User.fetch(token: "changhyeontoken123") { (temp) in
            let json = temp["data"]
            print(json)
            API.User.setUser(fromJSON: json)
            API.User.setBooks(fromJSON: json)
            API.User.setContents(fromJSON: json)
            
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nonLoginPressed(_ sender: Any) {
        
        let sampleStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let homeView  = sampleStoryBoard.instantiateViewController(withIdentifier: "MainVC") as! MainVC

        self.present(homeView, animated: true, completion: nil)

    }
    
}
