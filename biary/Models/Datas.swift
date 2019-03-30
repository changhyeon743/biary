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
import FBSDKLoginKit
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
    
    func loadBooks() -> [Book] {
        var books = try? Disk.retrieve("datas/books.json", from: .documents, as: [Book].self)
//        API.user.fetch(token: "1VJCNGZAdo0H1D6") { (json) in
//            books = Book.transformBook(fromJSON: JSON(json)["data"]["books"])
//        }
        if let book = books{
            var flag = false
            for (index,i) in book.enumerated() {
                if i.isPublic == nil {
                    books?[index].isPublic = true
                    flag = true
                }
                if i.date == nil {
                    books?[index].date = Date()
                    flag = true
                }
            }
            if flag {
                //새로운 변수가 추가됐음
                API.data.saveBooks()
            }
        }
        
        
        return books ?? []
    }
    
    func loadUser() -> User {
        let user = try? Disk.retrieve("datas/user.json", from: .documents, as: User.self)
        return user ?? User.makeInitialUser()
        
    }
    
    func loadContents() -> [Content] {
        let contents = try? Disk.retrieve("datas/contents.json", from: .documents, as: [Content].self)
        return contents ?? []
        
    }
    
    func loadAll() {
        let book = API.data.loadBooks()
        print("df",book)
        API.currentBooks = book
        print(API.currentBooks)
        API.currentUser = API.data.loadUser()
        if(FBSDKAccessToken.current() != nil) {
            API.facebook.getFBfriendData()
        }
        
        print(API.currentBooks)
        API.currentContents = API.data.loadContents()
        
        
    }
}
