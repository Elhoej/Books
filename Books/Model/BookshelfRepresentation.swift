//
//  Bookshelf.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 23/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation

struct BookshelfRepresentation: Codable
{
    let shelfLink: String?
    let id: Int?
    
    enum CodingKeys: String, CodingKey
    {
        case shelfLink = "shelfLink"
        case id = "id"
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        shelfLink = try container.decodeIfPresent(String.self, forKey: .shelfLink)
    }
}
