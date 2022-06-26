//
//  BrandProductsCollectionViewCell.swift
//  Mercury-Store
//
//  Created by mac hub on 01/06/2022.
//

import UIKit
import RxSwift
import Toast_Swift

class BrandProductsCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    //
    @IBOutlet weak private var containerViewForBrandProductsCell: UIView!
    @IBOutlet weak private var productForBrandImage: UIImageView!
    @IBOutlet weak private var favouriteButton: UIButton!
    @IBOutlet weak private var productForBrandName: UILabel!
    @IBOutlet weak private var currencyLabel: UILabel!
    @IBOutlet weak private var productForBrandPrice: UILabel!
    // MARK: - Properties
    //
    let viewModel:ProductCellViewModelType = ProductCellViewModel()
    let disposeBag = DisposeBag()
    var item: Product? {
        didSet {
            guard let item = item else {
                return
            }
            configProductCell(item: item)
        }
    }
    // MARK: - Life cycle
    //
    func configProductCell(item:Product){
        guard let url = URL(string: item.image.src) else {
            return
        }
        productForBrandImage.downloadImage(url: url , placeholder: UIImage(named: "placeholder"), imageIndicator: .gray, completion: nil)
        productForBrandName.text = item.title
        productForBrandPrice.text = item.variants[0].price
        favouriteButton.favouriteState(state: viewModel.getFavouriteState(productID: item.id))
        favouriteButton.rx.tap.throttle(.milliseconds(5000), latest: false, scheduler: MainScheduler.instance).subscribe(onNext: { [ weak self ] in
            guard let self = self else{return}
            self.handleToggleFavourite()
        }).disposed(by: disposeBag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

}
//MARK: Private Handlers
//
extension BrandProductsCollectionViewCell {
    private func setupView() {
        containerViewForBrandProductsCell.layer.borderWidth = 0.5
        containerViewForBrandProductsCell.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        containerViewForBrandProductsCell.layer.cornerRadius = 12
        containerViewForBrandProductsCell.layer.masksToBounds = true
    }
    
    func handleToggleFavourite(){
        if viewModel.userID != nil {
            guard let item = item else { return  }
            let savedValue = SavedProductItem(inventoryQuantity: item.variants[0].inventoryQuantity, variantId: item.variants[0].id, productID: Decimal(item.id), productTitle: item.title, productImage: item.image.src, productPrice: Double(item.variants[0].price )! , productQTY: 0, producrState: productStates.favourite.rawValue)
            let favourite = self.viewModel.toggleFavourite(product: savedValue)
            self.favouriteButton.favouriteState(state: favourite)
            self.makeToast("Added to Favourite", duration: 3.0, position: .top)
        }
        else {
            self.showNotLogedDialog()
        }
    }
    
    func showNotLogedDialog(){
        let dialogMessage = UIAlertController(title: "", message: "please login to add items to favourite", preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        dialogMessage.addAction(ok)
        guard let parentVC = self.parentViewController else { return }
        parentVC.present(dialogMessage, animated: true, completion: nil)
    }
}
