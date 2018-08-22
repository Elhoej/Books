//
//  BookController.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 22/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation

class BookController
{
    let baseURL = URL(string: "https://www.googleapis.com/books/v1/")!
    
    private(set) var searchedBooks = [BookRepresentation]()
    private(set) var favourites = [BookRepresentation]()
    private(set) var readingNow = [BookRepresentation]()
    private(set) var toRead = [BookRepresentation]()
    private(set) var haveRead = [BookRepresentation]()
    
    init()
    {
        
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
                self.searchedBooks = bookRepresentations
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
                
                completion(nil)
                
            }).resume()
        }
    }
}























