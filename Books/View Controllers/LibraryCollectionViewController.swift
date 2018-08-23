//
//  LibraryCollectionViewController.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 21/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class LibraryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, BookshelfBarDelegate, BookshelfCellDelegate
{
    func showErrorAlert(with text: String)
    {
        showAlert(with: text)
    }
    
    func didSelectBook()
    {
        let bookDetailViewController = BookDetailViewController()
        navigationController?.pushViewController(bookDetailViewController, animated: true)
    }
    
    var bookController: BookController?
    let readingNowId = "readingNowId"
    let toReadId = "toReadId"
    let haveReadId = "haveReadId"
    let favouritesId = "favouritesId"
    
    lazy var bookshelfBar: BookshelfBar =
    {
        let bsb = BookshelfBar()
        bsb.delegate = self
        
        return bsb
    }()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.title = "Favourites"
        
        setupCollectionView()
        
        setupBookshelfBar()
    }
    
    private func setupCollectionView()
    {
        collectionView?.backgroundColor = .backgroundColor
        collectionView?.isPagingEnabled = true
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.register(BookshelfCell.self, forCellWithReuseIdentifier: favouritesId)
        collectionView?.register(ToReadCell.self, forCellWithReuseIdentifier: toReadId)
        collectionView?.register(HaveReadCell.self, forCellWithReuseIdentifier: haveReadId)
        collectionView?.register(ReadingNowCell.self, forCellWithReuseIdentifier: readingNowId)
    }
    
    func selectedBookshelfDidChange(to index: Int)
    {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        setTitle(for: index)
    }
    
    private func setTitle(for index: Int)
    {
        let titles = ["Favourites", "Reading now", "To read", "Have read"]
        navigationItem.title = titles[index]
    }
    
    private func setupBookshelfBar()
    {
        view.addSubview(bookshelfBar)
        bookshelfBar.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier = cellId(for: indexPath.item)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! BookshelfCell
        
        cell.delegate = self
        cell.bookController = self.bookController
//        cell.fetchBooks()
        
        return cell
    }
    
    private func cellId(for index: Int) -> String
    {
        if index == 1
        {
            return readingNowId
        }
        else if index == 2
        {
            return toReadId
        }
        else if index == 3
        {
            return haveReadId
        }
        else
        {
            return favouritesId
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height - 50)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        bookshelfBar.barViewLeftConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        bookshelfBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        setTitle(for: Int(index))
    }
    
}


















