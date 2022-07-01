//
//  UIImageView+Shadow.swift
//  Mercury-Store
//
//  Created by mac hub on 04/06/2022.
//

import UIKit.UIImageView
import SDWebImage

extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadius : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.layer.borderWidth = 1.0
        containerView.layer.shadowOffset = CGSize(width: 0, height: cornerRadius)
        containerView.layer.shadowRadius = 6.0
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadius).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
}
extension UIImageView {
    // Image download and cache using SDWebImage
    func downloadImage(url: URL, placeholder:UIImage?,imageIndicator:SDWebImageActivityIndicator, completion:((UIImage?, Error?) -> Void)?) {
        self.sd_imageIndicator = imageIndicator
        self.sd_setImage(with: url, placeholderImage: placeholder, options: .retryFailed, context: nil, progress: nil) { (img, error, cacheType, url) in
            if error != nil {
                if placeholder == nil {
                    self.image =  UIImage(named: "placeholder")
                } else {
                    self.image = placeholder
                }
            }
            if completion != nil {
                completion!(img, error)
            }
        }
    }
    
}
