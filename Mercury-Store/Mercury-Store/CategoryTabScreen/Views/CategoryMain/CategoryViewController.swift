//
//  CategoryViewController.swift
//  Mercury-Store
//
//  Created by mac hub on 16/05/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ProgressHUD

class CategoryViewController: UIViewController {
    
    // MARK: - IBOutlets
    //
    @IBOutlet weak var mainCategoryItems: UITableView!
    @IBOutlet var categoriesCollectionView: UICollectionView!
    // MARK: - Properties
    //
    private let disposeBag = DisposeBag()
    private var viewModel: CategoriesScreenViewModel!
    let connection = NetworkReachability.shared
    // MARK: - Set up
    //
    init(with viewModel: CategoriesScreenViewModel) {
        super.init(nibName: String(describing: CategoryViewController.self), bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    // MARK: - Life cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        initTableView()
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
        viewModel.goToSearchViewController()
    }
    
}
// MARK: - Extensions
extension CategoryViewController :UITableViewDelegate{
    
    private func initTableView(){
        mainCategoryItems.delegate = nil
        mainCategoryItems.dataSource = nil
        mainCategoryItems.rx.setDelegate(self).disposed(by: disposeBag)
        mainCategoryItems.applyShadow(cornerRadius: 12)
        let nib = UINib(nibName: "MainCategoryCellTableViewCell", bundle: nil)
        mainCategoryItems.separatorStyle = .none
        mainCategoryItems.register(nib, forCellReuseIdentifier: MainCategoryCellTableViewCell.identifier)
        setupReactiveMainCategoryTableData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MainCategoryCellTableViewCell
        viewModel.categoryDetails.categoryID = cell.item?.id ?? 0
    }
    // MARK: - Private handlers
    //
    private func setupReactiveMainCategoryTableData(){
        viewModel.categories.drive(mainCategoryItems.rx.items(cellIdentifier: MainCategoryCellTableViewCell.identifier, cellType: MainCategoryCellTableViewCell.self)){ index , element , cell in
            cell.config(item: element )
        }.disposed(by: disposeBag)
    }
    
    private func bindActivity() {
        viewModel.isLoading.drive(ProgressHUD.rx.isAnimating)
        .disposed(by: disposeBag)
    }
}
// MARK: - Extensions
extension CategoryViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func setupCollection(){
        categoriesCollectionView.delegate = nil
        categoriesCollectionView.dataSource = nil
        categoriesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        let nib = UINib(nibName: "CategoryItem", bundle: nil)
        categoriesCollectionView.register(nib, forCellWithReuseIdentifier: CategoryItem.identifier)
        viewModel.categoryDetails.productTypes.drive(categoriesCollectionView.rx.items(cellIdentifier: CategoryItem.identifier, cellType: CategoryItem.self)){[weak self] index , element , cell in
            guard let `self` = self else {fatalError()}
            cell.config(name: element , itemId: self.viewModel.categoryDetails.categoryID)
        }.disposed(by: disposeBag)
        
        categoriesCollectionView.rx.modelSelected(String.self).subscribe(onNext:{ type in
            let id = self.viewModel.categoryDetails.categoryID
            self.viewModel.gotToProductScreen(with: id, type: type)
        }).disposed(by: disposeBag)
    }
}
