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
    //MARK: - Properties
    
    let cellId = "bookCell"
    var bookController: BookController?
    
    lazy var searchBar: UISearchBar =
    {
        let sb = UISearchBar()
        sb.delegate = self
        sb.placeholder = "Search for books"
        sb.barTintColor = .barColor
        sb.setBackgroundImage(UIImage(), for: .any, barMetrics: UIBarMetrics.default)
        sb.backgroundColor = .barColor
        
        return sb
    }()
    
    //MARK: - Functions
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Search"
        
        hideKeyboardWhenTappedAround()
        setupCollectionView()
        setupSearchBar()
    }
    private func setupSearchBar()
    {
        view.addSubview(searchBar)
        searchBar.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 45)
    }
    
    private func setupCollectionView()
    {
        collectionView?.backgroundColor = .backgroundColor
        collectionView?.register(BookCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsetsMake(45, 0, 5, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(45, 0, 5, 0)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        bookController?.searchForBook(with: searchTerm, completion: { (error) in
            
            if error != nil
            {
                self.showAlert(with: "An error occured while searching for \(searchBar), please try again!")
                return
            }
            
            DispatchQueue.main.async {
                self.searchBar.resignFirstResponder()
                self.collectionView?.reloadData()
            }
        })
    }
    
    //MARK: - CollectionView Delegate & DataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return bookController?.searchedBooks.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BookCell

        let book = bookController?.searchedBooks[indexPath.item]
        
        if let urlString = book?.volumeInfo?.imageLinks?.thumbnail
        {
            cell.coverImageView.loadImageUsingCacheOrUrlString(urlString)
        }
        
        if let authors = book?.volumeInfo?.authors
        {
            cell.authorLabel.text = authors[0]
        }
        
        cell.titleLabel.text = book?.volumeInfo?.title
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let book = bookController?.searchedBooks[indexPath.item]
        let bookDetailViewController = BookDetailViewController()
        bookDetailViewController.bookController = self.bookController
        bookDetailViewController.bookRep = book
        navigationController?.pushViewController(bookDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (view.frame.width - 12) / 2, height: 270)
    }
    
}














