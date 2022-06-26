//
//  ColorsCollectionViewCell.swift
//  Mercury-Store
//
//  Created by mac hub on 25/06/2022.
//

import UIKit

class ColorsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerViewForColorCell: UIView!
    @IBOutlet weak var colorView: UIView!
    var item: String? {
        didSet {
            guard let item = item else {
                return
            }
            colorView.backgroundColor = UIColor(named: item)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.containerViewForColorCell.layoutIfNeeded()       // add this
        containerViewForColorCell.makeCircularView()
        self.containerViewForColorCell.clipsToBounds = true
        
        self.colorView.layoutIfNeeded()       // add this
        colorView.makeCircularView()
        colorView.applyShadow()
        self.colorView.clipsToBounds = true
        
    }
    
    private func setUpUI() {
        containerViewForColorCell.viewBorderWidth = 0.5
        colorView.viewBorderColor = .black
        colorView.viewBorderWidth = 0.5
        colorView.viewBorderColor = .black
        
    }

}
