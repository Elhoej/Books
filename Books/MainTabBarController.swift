//
//  ViewController.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 21/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, GoogleAuthViewControllerDelegate
{
    let bookController = BookController()
    var libraryCollectionViewController: LibraryCollectionViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        tabBar.tintColor = .backgroundColor
        tabBar.unselectedItemTintColor = .lightGray
        setupViewControllers()

        checkIfAuthorized()
    }
    
    private func checkIfAuthorized()
    {
        if !GoogleBooksAuthorizationClient.shared.isAuthorized()
        {
            DispatchQueue.main.async {
                let googleAuthViewController = GoogleAuthViewController()
                googleAuthViewController.delegate = self
                self.present(googleAuthViewController, animated: true, completion: nil)
            }
        }
        else
        {
//            didAuthorize()
        }
    }
    
    func didAuthorize()
    {
//        libraryCollectionViewController?.fetchBooks()
    }
    
    private func setupViewControllers()
    {
        let libraryLayout = UICollectionViewFlowLayout()
        libraryLayout.scrollDirection = .horizontal
        libraryLayout.minimumLineSpacing = 0
        libraryCollectionViewController = LibraryCollectionViewController(collectionViewLayout: libraryLayout)
        libraryCollectionViewController?.bookController = self.bookController
        let libraryNavController = UINavigationController(rootViewController: libraryCollectionViewController!)
        libraryNavController.navigationBar.isTranslucent = false
        libraryNavController.tabBarItem.title = "Library"
        libraryNavController.tabBarItem.image = UIImage(named: "literature")
        
        let searchLayout = UICollectionViewFlowLayout()
        let searchCollectionViewController = SearchCollectionViewController(collectionViewLayout: searchLayout)
        searchCollectionViewController.bookController = self.bookController
        let searchNavController = UINavigationController(rootViewController: searchCollectionViewController)
        searchNavController.navigationBar.isTranslucent = false
        searchNavController.tabBarItem.title = "Search"
        searchNavController.tabBarItem.image = UIImage(named: "search")
        
        
        viewControllers = [libraryNavController, searchNavController]
    }

}

