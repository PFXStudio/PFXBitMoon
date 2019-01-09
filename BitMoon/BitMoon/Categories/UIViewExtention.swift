//
//  UIViewExtention.swift
//  BitMoon
//
//  Created by succorer on 2018. 12. 19..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    static func emptyImageView(parentView: UIView) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "iconEmpty"))
        imageView.backgroundColor = DefineColors.kMainTintColor
        imageView.frame = parentView.frame
        imageView.contentMode = UIView.ContentMode.center
        imageView.tintColor = UIColor.white
        parentView.addSubview(imageView)
        // align imageView from the left and right
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": imageView]));
        
        // align imageView from the top and bottom
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": imageView]));

        return imageView
    }
}
