//
//  BookshelfCell.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 22/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class BookshelfBarCell: UICollectionViewCell
{
    let bookshelfNameLabel: UILabel =
    {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 13)
        
        return label
    }()
    
    override var isHighlighted: Bool
    {
        didSet
        {
            bookshelfNameLabel.textColor = isHighlighted ? .backgroundColor : .lightGray
        }
    }
    
    override var isSelected: Bool
    {
        didSet
        {
            bookshelfNameLabel.textColor = isSelected ? .backgroundColor : .lightGray
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setupViews()
    }
    
    private func setupViews()
    {
        addSubview(bookshelfNameLabel)
        bookshelfNameLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 28)
        bookshelfNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
