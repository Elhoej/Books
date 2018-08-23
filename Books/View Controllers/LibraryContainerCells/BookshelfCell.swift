//
//  BookshelfCell.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 22/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

protocol BookshelfCellDelegate: class
{
    func didSelectBook()
    func showErrorAlert(with text: String)
}

class BookshelfCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    let cellId = "bookCell"
    weak var delegate: BookshelfCellDelegate?
    var bookController: BookController?
    {
        didSet
        {
            fetchBooks()
        }
    }
    
    lazy var collectionView: UICollectionView =
    {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .backgroundColor
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        setupViews()
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func fetchBooks()
    {
        bookController?.fetchBooksForBookshelf(bookshelfIndex: "0", completion: { (error) in
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
    
    private func setupViews()
    {
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return bookController?.readingNow.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BookCell
        
        let book = bookController?.readingNow[indexPath.item]
        
        if let urlString = book?.volumeInfo?.imageLinks?.thumbnail
        {
            cell.coverImageView.loadImageUsingCacheWithUrlString(urlString)
        }
        
        cell.authorLabel.text = book?.volumeInfo?.authors![0]
        cell.titleLabel.text = book?.volumeInfo?.title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        delegate?.didSelectBook()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (frame.width - 12) / 2, height: 270)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}











