//
//  UIButton+RoundedCorners.swift
//  Mercury-Store
//
//  Created by mac hub on 08/06/2022.
//

import UIKit

extension UIButton {
    func makeRoundedCornerButton() {
        self.layer.cornerRadius = 12
    }
}

extension UIButton{
    func favouriteState(state:Bool){
        if(state){
            setImage(UIImage(systemName:"heart.fill"), for: .normal)
            tintColor = .red
        }else {
            setImage(UIImage(systemName:"heart"), for: .normal)
        }
    }
}
