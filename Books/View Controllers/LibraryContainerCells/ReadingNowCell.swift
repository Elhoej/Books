//
//  FavouritesCell.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 22/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class ReadingNowCell: FavouritesCell
{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return bookController?.readingNow.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BookCell
        
        let book = bookController?.readingNow[indexPath.item]
        
        if let urlString = book?.thumbnailUrl
        {
            cell.coverImageView.loadImageUsingCacheOrUrlString(urlString)
        }
        
        cell.authorLabel.text = book?.author
        cell.titleLabel.text = book?.title
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let book = bookController?.readingNow[indexPath.item]
        delegate?.didSelectBook(book: book!)
    }
}
