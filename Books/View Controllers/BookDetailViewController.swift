//
//  BookDetailViewController.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 22/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController
{
    let scrollView: UIScrollView =
    {
        let sv = UIScrollView()
        sv.bounces = false
        sv.backgroundColor = .clear
        
        return sv
    }()
    
    let coverImageView: UIImageView =
    {
        let iv = UIImageView(image: #imageLiteral(resourceName: "testimage"))
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let titleLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.sizeToFit()
        label.text = "Description"
        label.textColor = .black
        
        return label
    }()
    
    let authorLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.sizeToFit()
        label.text = "Description"
        
        return label
    }()
    
    let publisherLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
//        label.textColor = .darkGray
        label.textAlignment = .right
        label.sizeToFit()
        label.text = "Description"
        
        return label
    }()
    
    let dateLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        //        label.textColor = .darkGray
        label.textAlignment = .center
        label.sizeToFit()
        label.text = "Description"
        
        return label
    }()
    
    let bookshelfSegmentedControl: UISegmentedControl =
    {
        let sc = UISegmentedControl(items: ["Reading now", "To read", "Have read", "Favourites"])
        
        return sc
    }()
    
    let bookDescriptionTitleLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        
        return label
    }()
    
    let bookDescriptionTextView: UITextView =
    {
        let tv = UITextView()
        tv.isEditable = false
        tv.font = UIFont.systemFont(ofSize: 14)
//        tv.layer.borderColor = UIColor.barColor.cgColor
//        tv.layer.borderWidth = 1
        tv.text = "Description"
        tv.backgroundColor = .backgroundColor
    
        return tv
    }()
    
    let bookReviewTextView: UITextView =
    {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.layer.borderColor = UIColor.barColor.cgColor
        tv.layer.borderWidth = 1
        tv.text = "Description"
        tv.backgroundColor = .backgroundColor
        
        return tv
    }()
    
    let bookReviewTitleLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Review"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        
        return label
    }()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
        
        setupViews()
    }
    
    @objc private func handleSave()
    {
        
    }
    
    private func setupViews()
    {
        let width = view.frame.width - 24
        
        view.addSubview(scrollView)
        scrollView.addSubview(coverImageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(bookshelfSegmentedControl)
        scrollView.addSubview(bookDescriptionTitleLabel)
        scrollView.addSubview(bookDescriptionTextView)
        scrollView.addSubview(bookReviewTitleLabel)
        scrollView.addSubview(bookReviewTextView)
        
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        coverImageView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: view.frame.width, height: 300)
        
        titleLabel.anchor(top: nil, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        titleLabel.centerYAnchor.constraint(equalTo: coverImageView.bottomAnchor).isActive = true
        
        let horizontalStackView = UIStackView(arrangedSubviews: [authorLabel, dateLabel, publisherLabel])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = 0
        
        scrollView.addSubview(horizontalStackView)
        horizontalStackView.anchor(top: titleLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: width, height: 25)
        
        bookshelfSegmentedControl.anchor(top: horizontalStackView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 22, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: width, height: 30)
        
        bookDescriptionTitleLabel.anchor(top: bookshelfSegmentedControl.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 22, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        bookDescriptionTextView.anchor(top: bookDescriptionTitleLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: width, height: 200)
        
        bookReviewTitleLabel.anchor(top: bookDescriptionTextView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        bookReviewTextView.anchor(top: bookReviewTitleLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 12, paddingRight: 0, paddingBottom: -50, width: width, height: 200)
    }
}





























