//
//  BrandsTableViewCell.swift
//  Mercury-Store
//
//  Created by mac hub on 17/05/2022.
//

import UIKit
import RxSwift

class BrandsTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    //
    @IBOutlet weak private var containerViewForBrandsCollectionView: UIView!
    @IBOutlet weak private var brandsCollectionView: UICollectionView! {
        didSet {
            brandsCollectionView.register(UINib(nibName: BrandsCollectionViewCell.reuseIdentifier(), bundle: nil), forCellWithReuseIdentifier: BrandsCollectionViewCell.reuseIdentifier())
        }
    }
    
    // MARK: - Properties
    //
    private let disposeBag = DisposeBag()
    var viewModel: BrandsViewModel! {
        didSet {
            self.configure()
        }
    }
    // MARK: - Life cycle
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    private func setupCell() {
        self.contentView.applyShadow()
        self.containerViewForBrandsCollectionView.makeCorners(corners: [.topRight , .topLeft], radius: 30)
        self.containerViewForBrandsCollectionView.layer.borderWidth = 2.0
        self.containerViewForBrandsCollectionView.layer.borderColor = UIColor.gray.cgColor
        self.contentView.backgroundColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
// MARK: - Extensions
extension BrandsTableViewCell {
    // MARK: - Private handlers
    //
    private func bindCollectionView() {
        brandsCollectionView.dataSource = nil
        brandsCollectionView.delegate = nil
        
        viewModel.brands.drive(brandsCollectionView.rx.items(cellIdentifier: BrandsCollectionViewCell.reuseIdentifier(), cellType: BrandsCollectionViewCell.self)) {index, item, cell in
            cell.brandItem = item
            
        }.disposed(by: disposeBag)
    }
    
    private func bindSelectedItem() {
        brandsCollectionView.rx.modelSelected(SmartCollectionElement.self).subscribe(onNext:{[weak self] item in
            guard let `self` = self else {fatalError()}
            self.viewModel.goToBrandDetails(with: item)
            
        }).disposed(by: disposeBag)
    }
}
// MARK: - Extensions
extension BrandsTableViewCell {
    private func configure() {
        self.bindCollectionView()
        self.bindSelectedItem()
    }
}
