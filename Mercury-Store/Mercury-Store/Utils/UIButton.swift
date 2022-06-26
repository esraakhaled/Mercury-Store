//
//  UIButton.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 06/06/2022.
//

import Foundation
import UIKit
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
