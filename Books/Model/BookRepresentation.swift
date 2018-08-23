//
//  BookRepresentation.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 22/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation

struct BookRepresentation: Codable
{
    let id: String?
    let volumeInfo: VolumeInfo?
    
    enum CodingKeys: String, CodingKey
    {
        case id = "id"
        case volumeInfo = "volumeInfo"
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        volumeInfo = try container.decodeIfPresent(VolumeInfo.self, forKey: .volumeInfo)
    }
    
    struct VolumeInfo: Codable
    {
        let title: String?
        let authors: [String]?
        let publishedDate: String?
        let publisher: String?
        let averageRating: Float?
        let pageCount: Int16?
        let bookDescription: String?
        let imageLinks: ImageLink?
        
        enum CodingKeys: String, CodingKey
        {
            case title = "title"
            case authors = "authors"
            case publishedDate = "publishedDate"
            case publisher = "publisher"
            case averageRating = "averageRating"
            case pageCount = "pageCount"
            case bookDescription = "description"
            case imageLinks = "imageLinks"
        }
        
        init(from decoder: Decoder) throws
        {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            title = try container.decodeIfPresent(String.self, forKey: .title)
            authors = try container.decodeIfPresent([String].self, forKey: .authors)
            publishedDate = try container.decodeIfPresent(String.self, forKey: .publishedDate)
            publisher = try container.decodeIfPresent(String.self, forKey: .publisher)
            averageRating = try container.decodeIfPresent(Float.self, forKey: .averageRating)
            pageCount = try container.decodeIfPresent(Int16.self, forKey: .pageCount)
            bookDescription = try container.decodeIfPresent(String.self, forKey: .bookDescription)
            imageLinks = try container.decodeIfPresent(ImageLink.self, forKey: .imageLinks)
        }
        
        struct ImageLink: Codable
        {
            let thumbnail: String?
            
            enum CodingKeys: String, CodingKey
            {
                case thumbnail = "thumbnail"
            }
            
            init(from decoder: Decoder) throws
            {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
            }
        }
    }
}

struct BookRepresentations: Codable
{
    let items: [BookRepresentation]?
}

func !=(lhs: Book, rhs: BookRepresentation) -> Bool
{
    return lhs.title != rhs.volumeInfo?.title && lhs.id != rhs.id && lhs.author != rhs.volumeInfo?.authors![0] && lhs.bookDescription != rhs.volumeInfo?.bookDescription && lhs.publishedDate != rhs.volumeInfo?.publishedDate && lhs.publisher != rhs.volumeInfo?.publisher && lhs.thumbnailUrl != rhs.volumeInfo?.imageLinks?.thumbnail
}
