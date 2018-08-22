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
        self.publisher = bookRepresentation.publisher
        self.publishedDate = bookRepresentation.publishedDate
        self.coverUrl = bookRepresentation.imageLinks[0].medium
        self.thumbnailUrl = bookRepresentation.imageLinks[0].thumbnail
        self.pageCount = bookRepresentation.pageCount
        self.volumeInfo = bookRepresentation.volumeInfo as NSObject
        self.bookshelf = bookRepresentation.bookshelf
        self.averageRating = bookRepresentation.averageRating
    }
}
