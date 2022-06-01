//
//  ProductDetailsImageCollectionCell.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 01/06/2022.
//

import UIKit

class ProductDetailsImageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageDetails: UIImageView!
    static let identifier = "ProductDetailsImageCollectionCell"
    
    static func nib()->UINib{
        return UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
