//
//  ProductResultViewController.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 23/05/2022.
//

import UIKit
import RxSwift
import ProgressHUD

class ProductResultViewController: UIViewController {
    // MARK: - IBOutlets
    //
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var productCollectionView: UICollectionView!
    // MARK: - Properties
    //
    private let disposeBag = DisposeBag()
    private var viewModel:FilteredProductsViewModelType?
    let connection = NetworkReachability.shared
    // MARK: - Set up
    //
    init(with viewModel: FilteredProductsViewModelType) {
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
        setupCollectionView()
        bindActivity()
        createSearchBarButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        connection.checkNetwork(target: self)
    }
    
    private func createSearchBarButton() {
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBtnTapped))
        self.navigationItem.rightBarButtonItem = search
    }
    
    @objc func searchBtnTapped() {
        viewModel?.goToSearchScreen()
    }
    
    // MARK: - Private handlers
    //
    private func setupCollectionView(){
        productCollectionView.delegate = nil
        productCollectionView.dataSource = nil
        productCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        let nib = UINib(nibName: BrandProductsCollectionViewCell.reuseIdentifier(), bundle: nil)
        productCollectionView.register(nib, forCellWithReuseIdentifier: BrandProductsCollectionViewCell.reuseIdentifier())
        
        viewModel?.products.drive(productCollectionView.rx.items(cellIdentifier: BrandProductsCollectionViewCell.reuseIdentifier(), cellType: BrandProductsCollectionViewCell.self)){index , element , cell in
            cell.item = element
        }.disposed(by: disposeBag)
        productCollectionView.rx.modelSelected(Product.self).subscribe(onNext:{ type in
            self.viewModel?.goToProductDetail(with: type)
        }).disposed(by: disposeBag)
        
    }
    
    private func bindActivity() {
        viewModel?.isLoading.drive(ProgressHUD.rx.isAnimating)
        .disposed(by: disposeBag)
    }

    @IBAction func filterAction(_ sender: Any) {
        self.viewModel?.goToFilteredProductScreen()
    }

}
// MARK: - Extensions
extension ProductResultViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let padding: CGFloat =  20
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: 300)
    }
}
