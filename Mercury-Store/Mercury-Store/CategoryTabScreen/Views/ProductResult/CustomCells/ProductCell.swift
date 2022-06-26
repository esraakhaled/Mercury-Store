//
//  ProductCell.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 24/05/2022.
//

import UIKit

class ProductCell: UICollectionViewCell {
    // MARK: - IBOutlets
    //
    @IBOutlet weak var cellContainer: UIView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productIMG: UIImageView!
    // MARK: - Properties
    //
    static let identifier = "ProductCell"
    var cellClickAction:( (_ item:Product)->() )?
    var item:Product?
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
    }
    // MARK: - Private handlers
    //
    public func configure(item:Product){
        guard let url = URL(string: item.image.src) else {
            return
        }
        productIMG.downloadImage(url: url , placeholder: UIImage(named: "placeholder"), imageIndicator: .gray, completion: nil)
        
        productName.text = "\(item.title) \n\(item.variants[0].price)EGP"
        self.item = item
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cellContainer.addGestureRecognizer(tap)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let cellClickAction = cellClickAction else {
            return
        }
        cellClickAction(self.item!)
    }
}
