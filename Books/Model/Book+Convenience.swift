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
    case readingNow
    case toRead
    case haveRead
    case favourites
}

extension Book
{
    convenience init?(bookRepresentation: BookRepresentation, context: NSManagedObjectContext)
    {
        self.init(context: context)
        self.id = bookRepresentation.id
        self.publisher = bookRepresentation.volumeInfo?.publisher
        self.publishedDate = bookRepresentation.volumeInfo?.publishedDate
        self.coverUrl = bookRepresentation.volumeInfo?.imageLinks?.medium
        self.thumbnailUrl = bookRepresentation.volumeInfo?.imageLinks?.thumbnail
        self.pageCount = (bookRepresentation.volumeInfo?.pageCount)!
//        self.volumeInfo = bookRepresentation.volumeInfo as NSObject
//        self.bookshelf = bookRepresentation.bookshelf
        self.averageRating = (bookRepresentation.volumeInfo?.averageRating)!
    }
}
