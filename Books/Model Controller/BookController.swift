//
//  BookController.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 22/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation
import CoreData

class BookController
{
    let baseURL = URL(string: "https://www.googleapis.com/books/v1/")!
    
    private(set) var searchedBooks = [BookRepresentation]()
    private(set) var favourites = [Book]() //0
    private(set) var readingNow = [Book]() //3
    private(set) var toRead = [Book]() //2
    private(set) var haveRead = [Book]() //4
    
    init()
    {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchBooksForBookshelf(bookshelfIndex: "0") { (error) in
            if error != nil
            {
                NSLog("Error fetching books for bookshelf: 0")
                dispatchGroup.leave()
                return
            }
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchBooksForBookshelf(bookshelfIndex: "2") { (error) in
            if error != nil
            {
                NSLog("Error fetching books for bookshelf: 2")
                dispatchGroup.leave()
                return
            }
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchBooksForBookshelf(bookshelfIndex: "3") { (error) in
            if error != nil
            {
                NSLog("Error fetching books for bookshelf: 3")
                dispatchGroup.leave()
                return
            }
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchBooksForBookshelf(bookshelfIndex: "4") { (error) in
            if error != nil
            {
                NSLog("Error fetching books for bookshelf: 4")
                dispatchGroup.leave()
                return
            }
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.fetchBooks()
        }
    }
    
    func updateReview(on book: Book, with review: String, bookshelf: String)
    {
        let backgroundMoc = CoreDataManager.shared.container.newBackgroundContext()
        
        backgroundMoc.performAndWait {
            book.review = review
            book.bookshelf = bookshelf
        }
        
        do {
            try CoreDataManager.shared.saveContext()
            fetchBooks()
        } catch {
            NSLog("Error updating review on persistence: \(error)")
            return
        }
    }
    
    func fetchBooks()
    {
        favourites.removeAll()
        readingNow.removeAll()
        toRead.removeAll()
        haveRead.removeAll()
        let fetchRequest = NSFetchRequest<Book>(entityName: "Book")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            
            let books = try CoreDataManager.shared.mainContext.fetch(fetchRequest)
            print(books.count)
            
            for book in books
            {
                if book.bookshelf == "0"
                {
                    self.favourites.append(book)
                }
                else if book.bookshelf == "2"
                {
                    self.toRead.append(book)
                }
                else if book.bookshelf == "3"
                {
                    self.readingNow.append(book)
                }
                else if book.bookshelf == "4"
                {
                    self.haveRead.append(book)
                }
            }
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCollectionView"), object: nil)
            }
            
        } catch let fetchErr {
            print("Failed to fetch books:", fetchErr)
            return
        }
    }
    
    func searchForBook(with searchTerm: String, completion: @escaping (Error?) -> ())
    {
        let url = baseURL.appendingPathComponent("volumes")
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let searchQueryItem = URLQueryItem(name: "q", value: searchTerm)
        urlComponents.queryItems = [searchQueryItem]
        
        guard let urlRequest = urlComponents.url else {
            NSLog("Failed to create URLRequest")
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: urlRequest)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error
            {
                NSLog("Failed to search for books: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Error unwrapping data")
                completion(NSError())
                return
            }
            
            do {
                let bookRepresentations = try JSONDecoder().decode(BookRepresentations.self, from: data).items
                self.searchedBooks = bookRepresentations!
                completion(nil)
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(error)
                return
            }
            
        }.resume()
    }
    
    func addBookToBookshelf(with bookId: String, on bookshelf: String, completion: @escaping (Error?) -> ())
    {
        let url = baseURL.appendingPathComponent("mylibrary").appendingPathComponent("bookshelves").appendingPathComponent(bookshelf).appendingPathComponent("addVolume")
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let addBookQueryItem = URLQueryItem(name: "volumeId", value: bookId)
        urlComponents.queryItems = [addBookQueryItem]
        
        guard let urlRequest = urlComponents.url else {
            NSLog("Failed to create url request")
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: urlRequest)
        request.httpMethod = "POST"
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (authRequest, error) in
            
            if let error = error
            {
                NSLog("Failed to add auth to request: \(error)")
                completion(error)
                return
            }
            
            guard let authRequest = authRequest else{
                NSLog("Authrequest was nil")
                completion(NSError())
                return
            }
            
            URLSession.shared.dataTask(with: authRequest, completionHandler: { (data, _, error) in
                
                if let error = error
                {
                    NSLog("Datatask to add book failed: \(error)")
                    completion(error)
                    return
                }
                
                self.fetchBooks()
                completion(nil)
                
            }).resume()
        }
    }
    
    func fetchBooksForBookshelf(bookshelfIndex: String, completion: @escaping (Error?) -> ())
    {
        print(bookshelfIndex)
        
        let url = baseURL.appendingPathComponent("mylibrary").appendingPathComponent("bookshelves").appendingPathComponent(bookshelfIndex).appendingPathComponent("volumes")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (authRequest, error) in
            
            guard let authRequest = authRequest else {
                NSLog("Authrequest is nil")
                completion(NSError())
                return
            }
            
            if let error = error
            {
                NSLog("An error occured while getting auth url: \(error)")
                completion(error)
                return
            }
            
            URLSession.shared.dataTask(with: authRequest, completionHandler: { (data, _, error) in
                
                if let error = error
                {
                    NSLog("Error fetching book for bookshelf: \(error)")
                    completion(error)
                    return
                }
                
                guard let data = data else {
                    NSLog("Error unwrapping data")
                    completion(NSError())
                    return
                }
                
                do {
                    let bookRepresentations = try JSONDecoder().decode(BookRepresentations.self, from: data).items
                    
                    if let bookReps = bookRepresentations
                    {
                        let backgroundMoc = CoreDataManager.shared.container.newBackgroundContext()
                        try self.updateBooks(with: bookReps, bookshelfIndex: bookshelfIndex, context: backgroundMoc)
                    }
                    
                    completion(nil)
                } catch {
                    NSLog("Error decoding data: \(error)")
                    completion(error)
                    return
                }
                
            }).resume()
        }
    }
    
    private func updateBooks(with representations: [BookRepresentation], bookshelfIndex: String, context: NSManagedObjectContext) throws
    {
        var error: Error?

        context.performAndWait {

            for bookRep in representations
            {
                let book = self.fetchSingleBookFromPersistence(identifier: bookRep.id!, context: context)

                if book == nil
                {
                    let _ = Book(bookRepresentation: bookRep, bookshelf: bookshelfIndex, context: context)
                }
            }

            do {
                try CoreDataManager.shared.saveContext(context: context)
            } catch let saveError {
                error = saveError
            }
        }

        if let error = error { throw error }
    }
    
    func fetchSingleBookFromPersistence(identifier: String, context: NSManagedObjectContext) -> Book?
    {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", identifier)
        do {
            let moc = CoreDataManager.shared.mainContext
            return try moc.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching book: \(error)")
            return nil
        }
    }
}























