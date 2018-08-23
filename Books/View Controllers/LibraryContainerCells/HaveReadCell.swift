//
//  HaveReadCell.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 22/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class HaveReadCell: BookshelfCell
{
    override func fetchBooks()
    {
        bookController?.fetchBooksForBookshelf(bookshelfIndex: "3", completion: { (error) in
            if error != nil
            {
                self.delegate?.showErrorAlert(with: "An error occured while loading your bookshelf, please check your connection and try again!")
                return
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return bookController?.haveRead.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BookCell
        
        let book = bookController?.haveRead[indexPath.item]
        
        if let urlString = book?.volumeInfo?.imageLinks?.thumbnail
        {
            cell.coverImageView.loadImageUsingCacheWithUrlString(urlString)
        }
        
        cell.authorLabel.text = book?.volumeInfo?.authors![0]
        cell.titleLabel.text = book?.volumeInfo?.title
        
        return cell
    }
}
