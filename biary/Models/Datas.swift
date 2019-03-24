//
//  Datas.swift
//  biary
//
//  Created by 이창현 on 18/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import Disk
import FBSDKCoreKit
import SwiftyJSON

class Datas {
    func saveBooks() {
        //activityIndicator.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try Disk.save(API.currentBooks, to: .documents, as: "datas/books.json")
            } catch {
                // ...
            }
            DispatchQueue.main.async {
                //activityIndicator.stopAnimating()
                // ...
            }
        }
    }
    
    func saveUser() {
        //activityIndicator.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try Disk.save(API.currentUser, to: .documents, as: "datas/user.json")
            } catch {
                // ...
            }
            DispatchQueue.main.async {
                //activityIndicator.stopAnimating()
                // ...
            }
        }
    }
    
    func saveContents() {
        //activityIndicator.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try Disk.save(API.currentContents, to: .documents, as: "datas/contents.json")
            } catch {
                // ...
            }
            DispatchQueue.main.async {
                //activityIndicator.stopAnimating()
                // ...
            }
        }
    }
    
    func loadBooks() -> [Book]? {
        
        do {
            let books = try Disk.retrieve("datas/books.json", from: .documents, as: [Book].self)
            return books
        } catch {
            
        }
        
        return nil
    }
    
    func loadUser() -> User? {
        
        do {
            let user = try Disk.retrieve("datas/user.json", from: .documents, as: User.self)
            return user
        } catch {
            
        }
        
        return nil
    }
    
    func loadContents() -> [Content]? {
        
        do {
            let contents = try Disk.retrieve("datas/contents.json", from: .documents, as: [Content].self)
            return contents
        } catch {
            
        }
        
        return nil
    }
    
    func loadAll() {
        API.currentBooks = API.data.loadBooks() ?? []
        if let user = API.data.loadUser() {
            API.currentUser = user
        } else {
            API.currentUser = User.makeInitialUser()
            API.user.register(name: API.currentUser.name, facebookId: API.currentUser.facebookId, profileURL: API.currentUser.profileURL, token: API.currentUser.token) { (json) in
                print(json);
                print(API.currentUser.token)
            }
        }
        if(FBSDKAccessToken.current() != nil) {
            API.facebook.getFBfriendData()
        }
        
        print(API.currentFriends)
        API.currentContents = API.data.loadContents() ?? []
    }
}
