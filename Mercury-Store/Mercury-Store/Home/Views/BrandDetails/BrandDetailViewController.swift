//
//  BrandDetailViewController.swift
//  Mercury-Store
//
//  Created by mac hub on 01/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

class BrandDetailViewController: UIViewController {
    @IBOutlet weak private var containerViewForBrandImage: UIView!
    @IBOutlet weak private var brandImageView: UIImageView!
    @IBOutlet weak private var brandTitleLabel: UILabel!
    @IBOutlet weak private var brandBodyHtmlLabel: UILabel!
    @IBOutlet weak private var productsForBrandCollectionView: UICollectionView! {
        didSet {
            productsForBrandCollectionView.register(UINib(nibName: BrandProductsCollectionViewCell.reuseIdentifier(), bundle: nil), forCellWithReuseIdentifier: BrandProductsCollectionViewCell.reuseIdentifier())
        }
    }
    
    private let disposeBag = DisposeBag()
    private var viewModel: BrandDetailsViewModelType!
    
    init(with viewModel: BrandDetailsViewModelType) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        
    }

}

//MARK: Private Handlers
//
extension BrandDetailViewController {
    private func configure() {
        self.bindCollectionView()
        setupView()
        showContent()
    }
}

extension BrandDetailViewController {
    private func bindCollectionView() {
        productsForBrandCollectionView.dataSource = nil
        productsForBrandCollectionView.delegate = nil
        viewModel.productsForBrand.drive(productsForBrandCollectionView.rx.items(cellIdentifier: BrandProductsCollectionViewCell.reuseIdentifier(), cellType: BrandProductsCollectionViewCell.self)) { index, item , cell in
            cell.item = item
        }.disposed(by: disposeBag)
        viewModel.fetchData()
    }
    
    private func setupView() {
        containerViewForBrandImage.applyShadow(cornerRadius: 12)
    }
    
    private func showContent() {
        let item = viewModel.item
        guard let url = URL(string: item.image.src) else {
            return
        }
        brandImageView.downloadImage(url: url , placeholder: UIImage(named: "placeholder"), imageIndicator: .gray, completion: nil)
        brandTitleLabel.text = item.title
        brandBodyHtmlLabel.text = item.bodyHTML
    }
}
