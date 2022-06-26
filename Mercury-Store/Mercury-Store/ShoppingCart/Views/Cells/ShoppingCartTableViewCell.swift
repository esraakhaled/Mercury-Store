//
//  ShoppingCartTableViewCell.swift
//  Mercury-Store
//
//  Created by mac hub on 26/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

class ShoppingCartTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //
    @IBOutlet weak private var containerViewForProductImage: UIView!
    @IBOutlet weak private var productImageCart: UIImageView!
    @IBOutlet weak private var productNameCart: UILabel!
    @IBOutlet weak var containerViewForShoppingCartCell: UIView!
    @IBOutlet weak private var productPriceCart: UILabel!
    @IBOutlet weak private var stackViewForQuantity: UIStackView!
    @IBOutlet weak private var quantityLabel: UILabel!
    @IBOutlet weak private var incrementQuantityButton: UIButton!
    @IBOutlet weak private var decrementQuantityButton: UIButton!
    @IBOutlet weak private var deleteButton: UIButton!
    // MARK: - Properties
    //
    var incrementTap: ControlEvent<Void> { self.incrementQuantityButton.rx.tap }
    var decrementTap: ControlEvent<Void> { self.decrementQuantityButton.rx.tap }
    var deleteTap: ControlEvent<Void> { self.deleteButton.rx.tap }
    var delegate: ShoppingCartViewController?
    private(set) var disposeBag = DisposeBag()
    // MARK: - Life cycle
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupCell() {
        self.containerViewForShoppingCartCell.applyShadow(cornerRadius: 12)
        self.productImageCart.layer.cornerRadius = 12
        self.containerViewForShoppingCartCell.layer.borderWidth = 0.5
        self.containerViewForShoppingCartCell.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.stackViewForQuantity.layer.cornerRadius = 8
        self.productImageCart.layer.borderWidth = 0.5
        self.productImageCart.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    }
   
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
}

// MARK: - Extensions
extension ShoppingCartTableViewCell {

    func bind(viewModel: CartCellViewModel, incrementObserver: AnyObserver<SavedProductItem>, decrementObserver: AnyObserver<SavedProductItem>, deleteObserver: AnyObserver<SavedProductItem>) {
        guard let image = viewModel.image else {return}
        guard let url = URL(string: image) else {fatalError()}
        productImageCart.downloadImage(url: url, placeholder: UIImage(named: "placeholder"), imageIndicator: .gray, completion: nil)
        productNameCart.text = viewModel.name
        productPriceCart.text = viewModel.price
        quantityLabel.text = viewModel.count
        
        self.incrementTap
            .map { viewModel.product }
            .bind(to: incrementObserver)
            .disposed(by: disposeBag)
        
        self.decrementTap
            .map { viewModel.product }
            .bind(to: decrementObserver)
            .disposed(by: disposeBag)
        
        self.deleteTap
            .withUnretained(self)
            .flatMapLatest{ s, _ in s.deleteItem()}
            .filter { $0 == .default}
            .map{ _ in viewModel.product }
            .bind(to: deleteObserver)
            .disposed(by: disposeBag)
    }
    fileprivate func deleteItem() -> Observable<UIViewController.AlertAction> {
        guard let delegate = delegate else { fatalError()}
        return delegate.alert(title: "Delete Item",
                     message: "Would you like to delete this item?",
                     defaultTitle: "OK",
                     cancelTitle: "Cancel")
         
    }
}


