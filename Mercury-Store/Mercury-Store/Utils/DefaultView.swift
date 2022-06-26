//
//  DefaultView.swift
//  Mercury-Store
//
//  Created by mac hub on 19/06/2022.
//

import UIKit

class DefaultView: UIView {


    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(color:UIColor,raduis:CGFloat) {
        super.init(frame: .zero)
        configure()
        self.backgroundColor    = color
        self.layer.cornerRadius = raduis
    }
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
    }
    

    
    
}
