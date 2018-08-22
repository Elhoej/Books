//
//  BookCell.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 22/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class BookCell: UICollectionViewCell
{
    let coverImageView: UIImageView =
    {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true

        return iv
    }()
    
    let titleLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    let authorLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        
        return label
    }()
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI()
    {
        addSubview(coverImageView)
        addSubview(titleLabel)
        addSubview(authorLabel)
        
        coverImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: -50, width: 0, height: 0)
        
        titleLabel.anchor(top: coverImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 30)
        
        authorLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
    }
    
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
