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
    //MARK: - Properties
    
    var bookController: BookController?
    var bookRep: BookRepresentation?
    {
        didSet
        {
            updateViews()
        }
    }
    var book: Book?
    {
        didSet
        {
            updateViews()
        }
    }
    
    //MARK: - UI Objects
    
    let scrollView: UIScrollView =
    {
        let sv = UIScrollView()
        sv.bounces = false
        sv.backgroundColor = .clear
        
        return sv
    }()
    
    let coverImageView: UIImageView =
    {
        let iv = UIImageView()
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
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.sizeToFit()
        label.numberOfLines = 0
        
        return label
    }()
    
    let publisherLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.textColor = .black
        label.sizeToFit()
        label.numberOfLines = 0
        
        return label
    }()
    
    let dateLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .black
        label.textAlignment = .right
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
        label.text = "About the book"
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
    
    //MARK: - Functions
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        hideKeyboardWhenTappedAround()
        setupNavBar()
        setupViews()
        setupKeyboardObservers()
    }
    
    private func setupNavBar()
    {
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
        let deleteBarButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDelete))
        navigationItem.rightBarButtonItems = [saveBarButton, deleteBarButton]
        
        if book == nil
        {
            navigationItem.rightBarButtonItems![1].isEnabled = false
            navigationItem.rightBarButtonItems![1].tintColor = .clear
        }
        else
        {
            navigationItem.rightBarButtonItems![1].isEnabled = true
            navigationItem.rightBarButtonItems![1].tintColor = .red
        }
    }
    
    private func setupKeyboardObservers()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func handleKeyboardWillShow(_ notification: Notification)
    {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        guard let height = keyboardFrame?.height else { return }
        
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.reviewTextViewBottomAnchor?.constant =  -height
        }) { (completed) in
            
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    @objc private func handleKeyboardWillHide(_ notification: Notification)
    {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        reviewTextViewBottomAnchor?.constant = -50
        
        UIView.animate(withDuration: keyboardDuration!, animations: {
                self.view.layoutIfNeeded()
        })
    }
    
    @objc private func handleDelete()
    {
        let alert = UIAlertController(title: "Are you sure you want to remove \(book?.title ?? "") from your bookshelf?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            
            guard let book = self.book, let bookshelf = book.bookshelf else {
                NSLog("Error unwrapping book for deletion")
                return
            }
            
            self.bookController?.delete(book: book, from: bookshelf, completion: { (error) in
                
                if error != nil
                {
                    self.showAlert(with: "An error occured while deleting your book, please try again!")
                    return
                }
                
                DispatchQueue.main.async {
                    self.bookController?.deleteFromCoreData(book: book)
                    self.navigationController?.popViewController(animated: true)
                }
            })
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func handleSave()
    {
        if let _ = bookRep
        {
            createNewBook()
        }
        else
        {
            guard let review = bookReviewTextView.text, let book = book else { return }
            let bookshelf = bookshelfIndexString(from: bookshelfSegmentedControl.selectedSegmentIndex)
            bookController?.update(on: book, with: review, bookshelf: bookshelf)
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func createNewBook()
    {
        guard let id = bookRep?.id, let title = bookRep?.volumeInfo?.title, let review = bookReviewTextView.text else {
            self.showAlert(with: "Something went wrong, please restart the app and try again.")
            return
        }
        
        let index = bookshelfSegmentedControl.selectedSegmentIndex
        let bookshelf = bookshelfIndexString(from: index)
        
        let _ = Book(bookRepresentation: bookRep!, review: review, bookshelf: bookshelf, context:
            CoreDataManager.shared.mainContext)
        do {
            try CoreDataManager.shared.saveContext()
        } catch {
            print("failed to save")
            return
        }
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
    
    //helper function
    private func bookshelfIndexString(from index: Int) -> String
    {
        switch index {
        case 0:
            return Bookshelf.favourites.rawValue
        case 1:
            return Bookshelf.readingNow.rawValue
        case 2:
            return Bookshelf.toRead.rawValue
        case 3:
            return Bookshelf.haveRead.rawValue
        default:
            return ""
        }
    }
    
    private func updateViews()
    {
        if let bookRep = bookRep
        {
            if let urlString = bookRep.volumeInfo?.imageLinks?.thumbnail
            {
                coverImageView.loadImageUsingCacheOrUrlString(urlString)
            }
            
            titleLabel.text = bookRep.volumeInfo?.title
            if let author = bookRep.volumeInfo?.authors![0]
            {
                authorLabel.text = "By \(author)"
            }
            dateLabel.text = bookRep.volumeInfo?.publishedDate
            publisherLabel.text = "Published by\n\(bookRep.volumeInfo?.publisher ?? "")"
            bookDescriptionTextView.text = bookRep.volumeInfo?.bookDescription
        }
        else if let book = book
        {
            if let urlString = book.thumbnailUrl
            {
                coverImageView.loadImageUsingCacheOrUrlString(urlString)
            }
            
            if var bookshelfIndex = Int(book.bookshelf!)
            {
                if bookshelfIndex == 3
                {
                    bookshelfIndex = 1
                }
                else if bookshelfIndex == 4
                {
                    bookshelfIndex = 3
                }
                
                bookshelfSegmentedControl.selectedSegmentIndex = bookshelfIndex
            }
            
            titleLabel.text = book.title
            authorLabel.text = "By \(book.author ?? "")"
            dateLabel.text = book.publishedDate
            publisherLabel.text = ("Published by\n\(book.publisher ?? "")")
            bookDescriptionTextView.text = book.bookDescription
            bookReviewTextView.text = book.review
        }
    }
    
    //MARK: - AutoLayout
    
    var reviewTextViewBottomAnchor: NSLayoutConstraint?
    
    private func setupViews()
    {
        let width = view.frame.width - 24
        
        view.addSubview(scrollView)
        scrollView.addSubview(coverImageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(authorLabel)
        scrollView.addSubview(publisherLabel)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(bookshelfSegmentedControl)
        scrollView.addSubview(bookDescriptionTitleLabel)
        scrollView.addSubview(bookDescriptionTextView)
        scrollView.addSubview(bookReviewTitleLabel)
        scrollView.addSubview(bookReviewTextView)
        
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        coverImageView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 9, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: view.frame.width, height: 300)
        
        titleLabel.anchor(top: coverImageView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: width, height: 0)
        
        authorLabel.anchor(top: titleLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: width / 2, height: 0)
        
        publisherLabel.anchor(top: titleLabel.bottomAnchor, left: authorLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 12, paddingBottom: 0, width: width / 2, height: 0)
        
        dateLabel.anchor(top: publisherLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 0, paddingRight: 12, paddingBottom: 0, width: width / 2, height: 0)
        dateLabel.centerXAnchor.constraint(equalTo: publisherLabel.centerXAnchor).isActive = true
        
        bookshelfSegmentedControl.anchor(top: dateLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 22, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: width, height: 30)
        
        bookDescriptionTitleLabel.anchor(top: bookshelfSegmentedControl.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 22, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        bookDescriptionTextView.anchor(top: bookDescriptionTitleLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: width, height: 200)
        
        bookReviewTitleLabel.anchor(top: bookDescriptionTextView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        bookReviewTextView.anchor(top: bookReviewTitleLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: width, height: 200)
        reviewTextViewBottomAnchor = bookReviewTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -50)
        reviewTextViewBottomAnchor?.isActive = true
    }
}


