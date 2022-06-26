//
//  WishListCell.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 23/05/2022.
//

import UIKit

class WishListCell: UITableViewCell {
    // MARK: - IBOutlets
    //
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var deleteItem: UIButton!
    @IBOutlet weak var priceLable: UILabel!
    // MARK: - Properties
    //
    public var deleteCallback:( (_ item:SavedProductItem)->Void)?
    private var savedItem:SavedProductItem?
    public static let identifier = "WishListCell"
    // MARK: - Life cycle
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    // MARK: - Private handlers
    //
    func config(item:SavedProductItem){
        titleLable.text = item.productTitle
        priceLable.text = "\(item.productPrice)EGP"
        imgView.downloadImage(url: URL(string: item.productImage)! , placeholder: UIImage(named: "placeholder"), imageIndicator: .gray , completion: nil)
        savedItem = item
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        deleteItem.addGestureRecognizer(tap)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let deleteCallback = deleteCallback else {
            return
        }
        deleteCallback(savedItem!)
    }
    
}
