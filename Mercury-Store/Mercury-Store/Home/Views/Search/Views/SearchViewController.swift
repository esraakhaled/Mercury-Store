//
//  SearchViewController.swift
//  Mercury-Store
//
//  Created by mac hub on 16/05/2022.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import ProgressHUD
import DropDown

class SearchViewController: UIViewController, UIScrollViewDelegate {
    // MARK: - IBOutlets
    //
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var minimumPrice: UILabel!
    @IBOutlet weak var maximumPrice: UILabel!
    @IBOutlet weak var priceSlider: UISlider!
    @IBOutlet weak var productSearchbar: UISearchBar!
    @IBOutlet weak var sliderPrice: UISlider!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var productListCollectionView: UICollectionView! {
        didSet {
            productListCollectionView.register(UINib(nibName: BrandProductsCollectionViewCell.reuseIdentifier(), bundle: nil), forCellWithReuseIdentifier: BrandProductsCollectionViewCell.reuseIdentifier())
        }
    }
    // MARK: - Properties
    //
    private var viewModel: ProductSearchViewModel!
    private var bag = DisposeBag()
    private let dropDown = DropDown()
    private var filterIsPressed = true
    private var myButton: UIButton!
    let connection = NetworkReachability.shared
    // MARK: - Set up
    //
    init(with viewModel: ProductSearchViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Life cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        createSortBarButton()
        hideSlider()
        bindToSearchValue()
        bindSelectedItem()
        bindFilterBtn()
        bindSlider()
        bindPrice()
        bindActivity()
        viewModel?.fetchData()
        bind()
        bindEmptyViewHidden()
        setupUI()
        emptyView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        connection.checkNetwork(target: self)
    }
    // MARK: - Private handlers
    //
    private func setupUI() {
        minimumPrice.text = CurrencyHelper().checkCurrentCurrency("0")
        maximumPrice.text = CurrencyHelper().checkCurrentCurrency("300")
    }
    private func bindEmptyViewHidden() {
        let emptySearchGif = UIImage.gifImageWithName("emptySearch")
        emptyImageView.image = emptySearchGif
        self.viewModel.error
            .drive(emptyView.rx.isHidden)
            .disposed(by: bag)
    }
    private func createSortBarButton() {
        var config = UIButton.Configuration.tinted()
        config.title = "Sort"
        config.image = UIImage(systemName: "arrow.up.arrow.down")
        config.imagePlacement = .trailing
        config.cornerStyle = .capsule
        myButton = UIButton(configuration: config)
        
        myButton.addTarget(self, action: #selector(sortBtnTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: myButton)
    
        dropDown.anchorView = myButton
        dropDown.dataSource = viewModel.sortArray
    }
    
    @objc func sortBtnTapped() {
        dropDown.selectionAction = { (index: Int, item: String) in
            self.viewModel.acceptTitle(item)
        }
        
        dropDown.width = 200
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.show()
    }
    
    func bind() {
        guard let viewModel = viewModel else {
            fatalError("Couldn't unwrap viewModel")
        }
        
        productListCollectionView.delegate = nil
        productListCollectionView.dataSource = nil
        productListCollectionView.rx.setDelegate(self).disposed(by: bag)
        
        let output = viewModel.bind()
        
        output.filteredItems.bind(to: productListCollectionView.rx.items(dataSource: dataSource()))
            .disposed(by: bag)
        
    }
    private func hideSlider() {
        maximumPrice.isHidden = true
        minimumPrice.isHidden = true
        priceSlider.isHidden = true
    }
    
    func bindToSearchValue() {
        productSearchbar.rx.text
            .bind(to: viewModel!.searchByName)
            .disposed(by: bag)
    }
    
    
    private func bindSlider(){
        sliderPrice.rx.value
            .map{Int($0)}
            .bind(to: viewModel!.value)
            .disposed(by: bag)
    }
    
    private func bindPrice(){
        viewModel?.value.asDriver()
            .map { CurrencyHelper().checkCurrentCurrency("\($0)") }
            .drive(maximumPrice.rx.text)
            .disposed(by: bag)
    }
    
    private func bindFilterBtn(){
        filterBtn.rx.tap.bind {
            self.filterBtnIsPressed()
            
        }.disposed(by: bag)
    }

    private func bindActivity() {
        viewModel?.isLoadingData.drive(ProgressHUD.rx.isAnimating)
        .disposed(by: bag)
    }
    
    private func bindSelectedItem() {
        productListCollectionView.rx.modelSelected(Product.self).subscribe{ [weak self] item in

            self?.viewModel?.goToProductDetailFromSearch(with: item)
        }.disposed(by: bag)
    }
    
    private func filterBtnIsPressed(){
        if filterIsPressed{
            filterIsPressed = false
            minimumPrice.isHidden = false
            maximumPrice.isHidden = false
            priceSlider.isHidden = false
        }else{
            minimumPrice.isHidden = true
            maximumPrice.isHidden = true
            filterIsPressed = true
            priceSlider.isHidden = true
        }
    }
}
// MARK: - Extensions
extension SearchViewController {
    // MARK: - Private handlers
    //
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<SearchSection> {
        .init {datasource, collectionView, indexPath, row in
            let cell: BrandProductsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandProductsCollectionViewCell.reuseIdentifier(), for: indexPath) as! BrandProductsCollectionViewCell
        
            cell.item = row
           
            return cell
        }
    }
}



