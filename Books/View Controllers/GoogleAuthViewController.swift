//
//  LoginViewController.swift
//  Books
//
//  Created by Simon Elhoej Steinmejer on 21/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

protocol GoogleAuthViewControllerDelegate: class
{
    func didAuthorize()
}

class GoogleAuthViewController: UIViewController
{
    weak var delegate: GoogleAuthViewControllerDelegate?
    
    let backgroundImageView: UIImageView =
    {
        let iv = UIImageView(image: #imageLiteral(resourceName: "books-background"))
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    let titleLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Google Books"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let authButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.setTitle("Sign in with Google", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .googleBlue
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(handleGoogleAuth), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupUI()
        applyMotionEffect(view: backgroundImageView, magnitude: 20)
    }
    
    @objc private func handleGoogleAuth()
    {
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: self) { (error) in
            
            if let error = error
            {
                NSLog("Error authenticating with google: \(error)")
                self.showAlert(with: "An error occured, please try again!")
                return
            }
            
            self.dismiss(animated: true, completion: {
                self.delegate?.didAuthorize()
            })
        }
    }
    
    private func setupUI()
    {
        view.addSubview(backgroundImageView)
        view.addSubview(titleLabel)
        view.addSubview(authButton)
        
        backgroundImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: -50, paddingLeft: -50, paddingRight: -50, paddingBottom: 50, width: 0, height: 0)
        
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        authButton.anchor(top: titleLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 50, paddingLeft: 25, paddingRight: 25, paddingBottom: 0, width: 0, height: 50)
    }
    
    private func applyMotionEffect(view: UIView, magnitude: CGFloat)
    {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }
}



















