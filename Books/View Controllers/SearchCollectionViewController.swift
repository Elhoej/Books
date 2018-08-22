//
//  SearchCollectionViewController.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 21/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class SearchCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    let cellId = "bookCell"
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        collectionView?.backgroundColor = .backgroundColor
        
        collectionView?.register(BookCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BookCell
        
        cell.coverImageView.image = #imageLiteral(resourceName: "books-background")
        cell.authorLabel.text = "Simon elhoej steinmejer"
        cell.titleLabel.text = "Hihahuhe vol. 2"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.width - 24, height: 200)
    }
    
}














