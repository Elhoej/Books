//
//  Extensions.swift
//  KiefApp
//
//  Created by Simon Elhoej Steinmejer on 4/15/17.
//  Copyright © 2017 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

extension UIViewController
{
    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension UIViewController
{
    func showAlert(with text: String)
    {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIView
{
    func setGradientBackground(colorOne: CGColor, colorTwo: CGColor)
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne, colorTwo, colorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.2, y: 1.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView
{
    func loadImageUsingCacheWithUrlString(_ urlString: String, completion: (() -> ())? = nil) {
        
        self.image = nil

        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage
        {
            self.image = cachedImage
            completion?()
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

            if let error = error {
                print(error)
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    
                    self.image = downloadedImage
                    completion?()
                }
            })
        }).resume()
    }
}

extension UIColor
{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor
    {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let googleBlue = UIColor.rgb(red: 66, green: 133, blue: 244)
    static let backgroundColor = UIColor.rgb(red: 255, green: 238, blue: 200)
}

extension UIView
{
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat, paddingBottom: CGFloat, width: CGFloat, height: CGFloat)
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top
        {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left
        {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right
        {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom
        {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if width != 0
        {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0
        {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}














