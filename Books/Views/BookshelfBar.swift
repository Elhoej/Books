//
//  BookshelfBar.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 22/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

protocol BookshelfBarDelegate: class
{
    func selectedBookshelfDidChange(to index: Int)
}

class BookshelfBar: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{
    //MARK: - Properties
    
    let cellId = "bookshelfBarCell"
    let bookshelfNames = ["Favourites", "Reading now", "To read", "Have read"]
    weak var delegate: BookshelfBarDelegate?
    
    lazy var collectionView: UICollectionView =
    {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    //MARK: - Functions
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        backgroundColor = .barColor
        
        setupCollectionView()
        setupSelectedBookshelfBar()
    }
    
    var barViewLeftConstraint: NSLayoutConstraint?
    
    private func setupSelectedBookshelfBar()
    {
        let barView = UIView()
        barView.backgroundColor = .backgroundColor
        barView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(barView)
        
        barViewLeftConstraint = barView.leftAnchor.constraint(equalTo: leftAnchor)
        barViewLeftConstraint?.isActive = true
        barView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        barView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/4).isActive = true
        barView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    private func setupCollectionView()
    {
        collectionView.register(BookshelfBarCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .left)
    }
    
    //MARK: - CollectionView Delegate & DataSource
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        delegate?.selectedBookshelfDidChange(to: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BookshelfBarCell
        
        cell.bookshelfNameLabel.text = bookshelfNames[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
























