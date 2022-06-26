//
//  CategoriesCollectionViewCell.swift
//  Mercury-Store
//
//  Created by mac hub on 17/05/2022.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    //
    @IBOutlet weak private var containerViewForCategoriesCollectionViewCell: UIView!
    @IBOutlet weak private var categoryImageView: UIImageView!
    @IBOutlet weak private var categoryName: UILabel!
    @IBOutlet weak private var containerViewForCategoryImageView: UIView!
    // MARK: - Properties
    //
    var category: CategoryDataItem? {
        didSet {
            guard let category = category else {
                return
            }
            categoryName.text = category.name
            categoryImageView.image = UIImage(named: category.imageName)
            containerViewForCategoryImageView.backgroundColor = UIColor(hexString: category.colorHex)
        }
    }
    // MARK: - Life cycle
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    private func setupCell() {
        containerViewForCategoryImageView.makeCircularView()
        
        
    }

}
