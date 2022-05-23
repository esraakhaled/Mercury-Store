//
//  CategoriesCollectionViewCell.swift
//  Mercury-Store
//
//  Created by mac hub on 17/05/2022.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak private var containerViewForCategoriesCollectionViewCell: UIView!
    @IBOutlet weak private var categoryImageView: UIImageView!
    @IBOutlet weak private var categoryName: UILabel!
    @IBOutlet weak private var containerViewForCategoryImageView: UIView!
    
    var category: CategoryItem? {
        didSet {
            guard let category = category else {
                return
            }
            categoryName.text = category.name
            categoryImageView.image = UIImage(systemName: category.imageName)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    private func setupCell() {
        containerViewForCategoryImageView.makeCircularView()
        containerViewForCategoryImageView.backgroundColor = .green
        
    }

}
