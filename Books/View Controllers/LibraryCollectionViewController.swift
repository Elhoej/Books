//
//  LibraryCollectionViewController.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 21/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class LibraryCollectionViewController: UICollectionViewController
{
    let bookshelfBar: BookshelfBar =
    {
        let bsb = BookshelfBar()
        
        return bsb
    }()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Library"
        
        setupBookshelfBar()
    }
    
    private func setupBookshelfBar()
    {
        view.addSubview(bookshelfBar)
        bookshelfBar.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 50)
    }
    
    
}


