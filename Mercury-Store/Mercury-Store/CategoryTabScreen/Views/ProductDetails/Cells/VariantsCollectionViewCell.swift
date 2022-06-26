//
//  VariantsCollectionViewCell.swift
//  Mercury-Store
//
//  Created by mac hub on 25/06/2022.
//

import UIKit

class VariantsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerViewForVariantLabel: UIView!
    @IBOutlet weak var variantNameLabel: UILabel!
    
    var item: String? {
        didSet {
            guard let item = item else {
                return
            }
            variantNameLabel.text = item
        }
    }
    
    override var isHighlighted: Bool{
        didSet{
            variantNameLabel.textColor = isHighlighted ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            containerViewForVariantLabel.layer.backgroundColor = isHighlighted ? #colorLiteral(red: 0.9998229146, green: 0.5830360055, blue: 0, alpha: 1) : #colorLiteral(red: 0.9999235272, green: 1, blue: 0.9998829961, alpha: 1)
        }
    }
    
    override var isSelected: Bool{
        didSet{
            variantNameLabel.textColor = isSelected ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            containerViewForVariantLabel.layer.backgroundColor = isSelected ? #colorLiteral(red: 0.9631432891, green: 0.6232308745, blue: 0.0003859905701, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        containerViewForVariantLabel.makeCircularView()
        variantNameLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        containerViewForVariantLabel.viewBorderWidth = 0.5
        containerViewForVariantLabel.viewBorderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        containerViewForVariantLabel.layer.borderWidth = 0.5
        containerViewForVariantLabel.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        //variantNameLabel.layer.cornerRadius = 8
        containerViewForVariantLabel.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}
