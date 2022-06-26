//
//  CategoryItem.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 20/05/2022.
//

import UIKit
class CategoryItem: UICollectionViewCell {
   
    // MARK: - IBOutlets
    //
    @IBOutlet weak var containerViewForCategoriesCollectionViewCell: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var image: UIImageView!
    // MARK: - Properties
    //
    static let identifier = "CategoryItem"
    // MARK: - Set up
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    // MARK: - Life cycle
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    // MARK: - Private handlers
    //
    public func config(name:String , itemId:Int){
        title.text = name
        title.textColor = ColorsPalette.lightColor
        containerViewForCategoriesCollectionViewCell.backgroundColor = ColorsPalette.darkBlue
        image.image = UIImage(named: name)
    }
    private func setupCell() {
        containerViewForCategoriesCollectionViewCell.applyShadow(cornerRadius: 8)
    }
}
