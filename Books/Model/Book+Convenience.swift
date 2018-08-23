//
//  Book+Convenience.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 22/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit
import CoreData

enum Bookshelf: String
{
    case readingNow = "3"
    case toRead = "2"
    case haveRead = "4"
    case favourites = "0"
}

extension Book
{
    convenience init(bookRepresentation: BookRepresentation, review: String, bookshelf: String, context: NSManagedObjectContext = CoreDataManager.shared.mainContext)
    {
        self.init(context: context)
        self.id = bookRepresentation.id
        self.publisher = bookRepresentation.volumeInfo?.publisher
        self.publishedDate = bookRepresentation.volumeInfo?.publishedDate
        self.thumbnailUrl = bookRepresentation.volumeInfo?.imageLinks?.thumbnail
        self.bookDescription = bookRepresentation.volumeInfo?.bookDescription
        self.author = bookRepresentation.volumeInfo?.authors![0]
        self.title = bookRepresentation.volumeInfo?.title
        self.review = review
        self.bookshelf = bookshelf
    }
    
    convenience init?(bookRepresentation: BookRepresentation, bookshelf: String, context: NSManagedObjectContext)
    {
        self.init(context: context)
        self.id = bookRepresentation.id
        self.publisher = bookRepresentation.volumeInfo?.publisher
        self.publishedDate = bookRepresentation.volumeInfo?.publishedDate
        self.thumbnailUrl = bookRepresentation.volumeInfo?.imageLinks?.thumbnail
        self.bookDescription = bookRepresentation.volumeInfo?.bookDescription
        self.author = bookRepresentation.volumeInfo?.authors![0]
        self.title = bookRepresentation.volumeInfo?.title
        self.review = ""
        self.bookshelf = bookshelf
    }
}









