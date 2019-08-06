
//
//  Book.swift
//  biary
//
//  Created by 이창현 on 25/02/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import SwiftyJSON


/*
 "title": "나미야 잡화점의 기적",
 "author": "히가시노 게이고",
 "publisher": "현대문학",
 "isbn": "8972756199 9788972756194",
 "imageURL": "https://bookthumb-phinf.pstatic.net/cover/071/027/07102772.jpg?type=m1&udate=20181226",
 "writerToken": "threechanghyeon",
 "token": "token3",
 "description": "나미야 잡화점의 기적입니다.",
 "date": "2018-01-01T00:00:00.000Z",
 
 */
struct Book:Codable {
    var title: String
    var author: String
    var publisher: String
    var isbn: String
    var imageURL: String
    var writerToken: String
    var writerName: String
    var token: String
    var description: String
    var date: Date?
    var isPublic: Bool?
}

extension Book {
    static func transformBook(fromJSON json:JSON) -> Book {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let book = Book(title: json["title"].stringValue,
                                  author: json["author"].stringValue,
                                  publisher: json["publisher"].stringValue,
                                  isbn: json["isbn"].stringValue,
                                  imageURL: json["imageURL"].stringValue,
                                  writerToken: json["writerToken"].stringValue,
                                  writerName: json["writerName"].stringValue,
                                  token: json["token"].stringValue,
                                  description: json["description"].stringValue,
                                  date: dateFormatter.date(from: json["date"].stringValue) ?? Date(),
                                  isPublic: json["isPublic"].boolValue)
        
        //print(books)
        
        return book
    }
    
    static func transformBooks(fromJSON temp:JSON) -> [Book] {
        let json = temp.arrayValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let books = json.map{Book(title: $0["title"].stringValue,
                                  author: $0["author"].stringValue,
                                  publisher: $0["publisher"].stringValue,
                                  isbn: $0["isbn"].stringValue,
                                  imageURL: $0["imageURL"].stringValue,
                                  writerToken: $0["writerToken"].stringValue,
                                  writerName: $0["writerName"].stringValue,
                                  token: $0["token"].stringValue,
                                  description: $0["description"].stringValue,
                                  date: dateFormatter.date(from: $0["date"].stringValue) ?? Date(),
                                  isPublic: $0["isPublic"].boolValue)}
        
        //print(books)
        
        return books
    }
    
    static func transformNaverBook(fromJSON temp:JSON) -> [Book] {
        let json = temp["items"].arrayValue
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let books = json.map{Book(title: $0["title"].stringValue,
            author: $0["author"].stringValue,
            publisher: $0["publisher"].stringValue,
            isbn: $0["isbn"].stringValue,
            imageURL: $0["image"].stringValue,
            writerToken: "",
            writerName: "",
            token: "",
            description: $0["description"].stringValue,
            date: dateFormatter.date(from: $0["pubdate"].stringValue) ?? Date(),
            isPublic: true)}
        
        return books;
    }
    
    static func transformGoogleBook(fromJSON temp:JSON) -> [Book] {
        let json = temp["items"].arrayValue.map{$0["volumeInfo"]}
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let books = json.map{Book(title: $0["title"].stringValue,
                                  author: $0["authors"].arrayValue.map{$0.stringValue}.joined(separator: ","),
                                  publisher: $0["publisher"].stringValue,
                                  isbn: $0["industryIdentifiers"]["identifier"].stringValue,
                                  imageURL: $0["imageLinks"]["thumbnail"].stringValue,
                                  writerToken: "",
                                  writerName: "",
                                  token: "",
                                  description: $0["description"].stringValue,
                                  date: dateFormatter.date(from: $0["publishedDate"].stringValue) ?? Date(),
                                  isPublic: true)}
        
        return books;
    }
    
    static func append(title:String,author: String,publisher: String, isbn: String, imageURL: String, description: String, bookshelfs: [Bookshelf]) {
        let book = Book(title: title, author: author, publisher: publisher, isbn: isbn, imageURL: imageURL, writerToken: API.currentUser.token, writerName: API.currentUser.name, token: Token.create(), description: description, date: Date(),isPublic: true)
        
        API.currentBooks.append(book);
        
        Bookshelf.addBook(at: bookshelfs, bookToken: book.token)
    }
    
    static func edit(title:String,author: String,publisher: String, isbn: String, imageURL: String, description: String, bookshelfs: [Bookshelf],isPublic: Bool, bookToken: String) {
        
        let book = Book(title: title, author: author, publisher: publisher, isbn: isbn, imageURL: imageURL, writerToken: API.currentUser.token, writerName: API.currentUser.name, token: bookToken, description: description, date: Date(), isPublic: isPublic)
        
        API.currentBooks[Book.find(withToken: bookToken)] = book
        API.data.saveUser()
        API.data.saveBooks()
    }
    
    static func find(withToken token:String) -> Int{
        if (API.currentBooks.count != 0) {
            let index = API.currentBooks.firstIndex(where: { (book) -> Bool in
                return book.token == token
            }) ?? 0;
            return index
        } else {
            return 0
        }
    }
    
    static func find(withToken token:String,at books: [Book]) -> Int{
        if (books.count != 0) {
            let index = books.firstIndex(where: { (book) -> Bool in
                return book.token == token
            }) ?? 0;
            return index
        } else {
            return 0
        }
    }
    
    static func remove(withToken token:String) {
        API.currentBooks.remove(at: Book.find(withToken: token));
        Bookshelf.clean(bookToken: token)
    }
    
}


