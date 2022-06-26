//
//  ProductDetailsImageCollectionCell.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 03/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

class ProductDetailsImageCollectionCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var productImageDetails: UIImageView!
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    var item: ProductImage? {
        didSet {
            guard let item = item else {
                return
            }
            guard let url = URL(string: item.src) else {
                return
            }
            productImageDetails.downloadImage(url: url , placeholder: UIImage(named: "placeholder"), imageIndicator: .gray, completion: nil)
        }
    }
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
