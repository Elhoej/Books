//
//  BookRepresentation.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 22/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation

struct BookRepresentation
{
    let id: String
    let publishedDate: String
    let publisher: String
    let averageRating: Float
    let pageCount: Int16
    let bookDescription: String
    let imageLinks: [ImageLink]
    let volumeInfo: [VolumeInfo]
    let bookshelf: String?
    
    struct ImageLink
    {
        let thumbnail: String?
        let medium: String?
    }
    
    struct VolumeInfo
    {
        let title: String?
        let author: [String]
    }
}

//func !=(lhs: Book, rhs: BookRepresentation) -> Bool
//{
//    return lhs.title != rhs.title && lhs.id != rhs.id && lhs. != rhs.hasWatched
//}
