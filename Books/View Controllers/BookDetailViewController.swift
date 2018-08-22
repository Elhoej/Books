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
    var bookController: BookController?
    var book: BookRepresentation?
    {
        didSet
        {
            guard let book = book else { return }
            updateViews(with: book)
        }
    }
    
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
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    
    let authorLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.sizeToFit()
        label.numberOfLines = 0
        
        return label
    }()
    
    let publisherLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.textColor = .darkGray
        label.sizeToFit()
        label.numberOfLines = 0
        
        return label
    }()
    
    let dateLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    let bookshelfSegmentedControl: UISegmentedControl =
    {
        let sc = UISegmentedControl(items: ["Favourites", "Reading now", "To read", "Have read"])
        sc.selectedSegmentIndex = 0
        
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
        tv.backgroundColor = .backgroundColor
    
        return tv
    }()
    
    let bookReviewTextView: UITextView =
    {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.layer.borderColor = UIColor.barColor.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 4
        tv.layer.masksToBounds = true
        tv.backgroundColor = .backgroundColor
        
        return tv
    }()
    
    let bookReviewTitleLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Write a review"
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
        guard let id = book?.id, let title = book?.volumeInfo?.title else {
            showAlert(with: "Couldn't find book ID, please restart the app and try again.")
            return
        }
        
        let index = bookshelfSegmentedControl.selectedSegmentIndex
        let bookshelf = String(bookshelfSegmentedControl.selectedSegmentIndex)
        
        bookController?.addBookToBookshelf(with: id, on: bookshelf, completion: { (error) in
            
            if error != nil
            {
                self.showAlert(with: "Something went wrong when adding the book to your bookshelf, please try again!")
                return
            }
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Successfully added \(title) to \(self.bookshelfSegmentedControl.titleForSegment(at: index) ?? "")", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (_) in
                    
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    private func updateViews(with book: BookRepresentation)
    {
        if let urlString = book.volumeInfo?.imageLinks?.thumbnail
        {
            coverImageView.loadImageUsingCacheWithUrlString(urlString)
        }

        titleLabel.text = book.volumeInfo?.title
        authorLabel.text = book.volumeInfo?.authors![0]
        dateLabel.text = book.volumeInfo?.publishedDate
        publisherLabel.text = book.volumeInfo?.publisher
        bookDescriptionTextView.text = book.volumeInfo?.bookDescription
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
        
        titleLabel.anchor(top: coverImageView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: width, height: 0)
        
        let horizontalStackView = UIStackView(arrangedSubviews: [authorLabel, dateLabel, publisherLabel])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = 0
        
        scrollView.addSubview(horizontalStackView)
        horizontalStackView.anchor(top: titleLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: width, height: 40)
        
        bookshelfSegmentedControl.anchor(top: horizontalStackView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 22, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: width, height: 30)
        
        bookDescriptionTitleLabel.anchor(top: bookshelfSegmentedControl.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 22, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        bookDescriptionTextView.anchor(top: bookDescriptionTitleLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: width, height: 200)
        
        bookReviewTitleLabel.anchor(top: bookDescriptionTextView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        bookReviewTextView.anchor(top: bookReviewTitleLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 12, paddingRight: 0, paddingBottom: -50, width: width, height: 200)
    }
}





























