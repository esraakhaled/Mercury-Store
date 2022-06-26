//
//  DefaultImageView.swift
//  Mercury-Store
//
//  Created by mac hub on 19/06/2022.
//

import UIKit

class DefaultImageView: UIImageView {

    let placeHolder = "testImage"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImg()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImg(){
        clipsToBounds      = true
        image              = UIImage(named: placeHolder)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
