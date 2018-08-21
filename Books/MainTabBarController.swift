//
//  ViewController.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 21/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        GoogleBooksAuthorizationClient.shared.resetAuthorization()
        checkIfAuthorized()
        setupViewControllers()
    }
    
    private func checkIfAuthorized()
    {
        if !GoogleBooksAuthorizationClient.shared.getAuthorizationStatus()
        {
            DispatchQueue.main.async {
                let googleAuthViewController = GoogleAuthViewController()
                self.present(googleAuthViewController, animated: true, completion: nil)
            }
        }
    }
    
    private func setupViewControllers()
    {
        let libraryLayout = UICollectionViewFlowLayout()
        let libraryCollectionViewController = LibraryCollectionViewController(collectionViewLayout: libraryLayout)
        let libraryNavController = UINavigationController(rootViewController: libraryCollectionViewController)
        libraryNavController.tabBarItem.title = "Library"
        libraryNavController.tabBarItem.image = UIImage(named: "literature")
        
        let searchLayout = UICollectionViewFlowLayout()
        let searchCollectionViewController = SearchCollectionViewController(collectionViewLayout: searchLayout)
        searchCollectionViewController.tabBarItem.title = "Search"
        searchCollectionViewController.tabBarItem.image = UIImage(named: "search")
        
        
        viewControllers = [libraryNavController, searchCollectionViewController]
    }

}

