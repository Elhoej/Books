//
//  SearchCollectionViewController.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 21/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class SearchCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate
{
    let cellId = "bookCell"
    
    let searchBar: UISearchBar =
    {
        let sb = UISearchBar()
        sb.placeholder = "Search for books"
        sb.barTintColor = .barColor
        sb.setBackgroundImage(UIImage(), for: .any, barMetrics: UIBarMetrics.default)
        sb.backgroundColor = .barColor
        
        return sb
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Search"
        setupCollectionView()
        
        view.addSubview(searchBar)
        searchBar.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 45)
    }
    
    private func setupCollectionView()
    {
        collectionView?.backgroundColor = .backgroundColor
        collectionView?.register(BookCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsetsMake(45, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(45, 0, 0, 0)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //call bookcontroller.search
        searchBar.resignFirstResponder()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 4
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
        return CGSize(width: (view.frame.width - 12) / 2, height: 270)
    }
    
}














