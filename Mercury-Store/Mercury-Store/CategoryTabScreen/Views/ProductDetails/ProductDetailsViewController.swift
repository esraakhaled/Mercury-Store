//
//  ProductDetailsViewController.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 29/05/2022.
//

import UIKit
import RxSwift
import RxCocoa
import Toast_Swift
import Cosmos

class ProductDetailsViewController: UIViewController, UIScrollViewDelegate{
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerViewForAddToCartButton: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var imageControl: UIPageControl!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var productImagesCollectionView: UICollectionView! {
        didSet {
            productImagesCollectionView.register(UINib(nibName: ProductDetailsImageCollectionCell.reuseIdentifier(), bundle: nil), forCellWithReuseIdentifier: ProductDetailsImageCollectionCell.reuseIdentifier())
        }
    }
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var reviewImageView: UIImageView!
    @IBOutlet weak var reviewDate: UILabel!
    @IBOutlet weak var reviewContentLabel: UILabel!
    @IBOutlet weak var reviewMailLabel: UILabel!
    @IBOutlet weak var reviewRating: CosmosView!
    @IBOutlet weak var variantsCollectionView: UICollectionView! {
        didSet {
            variantsCollectionView.register(UINib(nibName: VariantsCollectionViewCell.reuseIdentifier(), bundle: nil), forCellWithReuseIdentifier: VariantsCollectionViewCell.reuseIdentifier())
        }
    }
    @IBOutlet weak var colorsCollectionView: UICollectionView! {
        didSet {
            colorsCollectionView.register(UINib(nibName: ColorsCollectionViewCell.reuseIdentifier(), bundle: nil), forCellWithReuseIdentifier: ColorsCollectionViewCell.reuseIdentifier())
        }
    }
    @IBOutlet weak var heightForVariantCollectionView: NSLayoutConstraint!
    @IBOutlet weak var inventoryQuantityLabel: UILabel!
    
    @IBOutlet weak var heightForColorCollectionView: NSLayoutConstraint!
    
    
    // MARK: - Properties
    private var viewModel: ProductsDetailViewModelType!
    private let disposeBag = DisposeBag()
    private let collectionViewFrame = ReplaySubject<CGRect>.create(bufferSize: 1)
    private var contentSizeObservation: NSKeyValueObservation?
    // MARK: - Set up
    init(with viewModel: ProductsDetailViewModelType) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUi()
        setUpUI()
        collectionViewFrame.onNext(self.productImagesCollectionView.frame)
        addObserverOnHeight()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    private func addObserverOnHeight() {
        contentSizeObservation = variantsCollectionView.observe(\.contentSize, options: .new, changeHandler: { [weak self] (cv, _) in
            guard let self = self else { return }
            self.heightForVariantCollectionView.constant = cv.collectionViewLayout.collectionViewContentSize.height
        })
        contentSizeObservation = colorsCollectionView.observe(\.contentSize, options: .new, changeHandler: { [weak self] (cv, _) in
            guard let self = self else { return }
            self.heightForColorCollectionView.constant = cv.collectionViewLayout.collectionViewContentSize.height
        })
    }

    private func setUpUI() {
        self.containerViewForAddToCartButton.makeCorners(corners: [.topLeft,.topRight], radius: 12)
        self.addToCart.tintColor = ColorsPalette.labelColors
        self.addToCart.configuration?.background.backgroundColor = ColorsPalette.lightColor
        closeButton.tintColor = ColorsPalette.lightColor
        productPriceLabel.textColor = ColorsPalette.lightColor
        self.descLabel.tintColor = ColorsPalette.lightColor
        let randomNumber = Int.random(in: 0..<ReviewRepository.reviewsArray.count)
        let item = ReviewRepository.reviewsArray[randomNumber]
        reviewImageView.image = UIImage(named: item.imageName)
        reviewDate.text = item.date
        reviewMailLabel.text = item.email
        reviewContentLabel.text = item.reviewContent
        reviewRating.rating = item.rating
        self.variantsCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
    }
    private func updateUi(){
        productTitleLabel.text = viewModel.product.title
        viewModel.priceObservable.subscribe (onNext: {[weak self] value in
            self?.productPriceLabel.text = CurrencyHelper().checkCurrentCurrency(value)
        }).disposed(by: disposeBag)
        
        productDescription.text = viewModel.product.bodyHTML
        viewModel.inventoryQuantityObservable.subscribe (onNext: {[weak self] value in
            if(value == 0) {
                self?.inventoryQuantityLabel.text = "Out of stock"
                self?.inventoryQuantityLabel.textColor = .red
            }else {
                self?.inventoryQuantityLabel.attributedText = self?.attributedText(withString: "\(value) available in stock", boldString: "\(value)", font: UIFont(name: "Optima Regular", size: 13.0)!)
                self?.inventoryQuantityLabel.textColor = .green
            }
        }).disposed(by: disposeBag)
        
        self.configure()
    }
    
    // MARK: - Private handlers
    private func bindCloseButton() {
        closeButton.rx.tap
            .subscribe {[weak self] _ in
                self?.viewModel.popViewController()
            }.disposed(by: disposeBag)
        
    }
    
    private func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    deinit {
        contentSizeObservation?.invalidate()
    }
}

// MARK: - Extensions
extension ProductDetailsViewController {
    // MARK: - Private handlers
    private func bindProductImagesCollectionView() {
        productImagesCollectionView.dataSource = nil
        productImagesCollectionView.delegate = nil
        productImagesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.bannerObservable
            .drive(productImagesCollectionView.rx.items(cellIdentifier:  ProductDetailsImageCollectionCell.reuseIdentifier(), cellType:  ProductDetailsImageCollectionCell.self)) {indexPath, item, cell in
                cell.item = item
            }
            .disposed(by: disposeBag)
        viewModel.sendImagesToCollection()
    }
    
    private func bindPageController() {
        viewModel.countForPageControll
            .bind(to: imageControl.rx.numberOfPages)
            .disposed(by: disposeBag)
    }
    
    private func bindCollectionViewToPageControll() {
        currentPage(
            offset: productImagesCollectionView.rx.contentOffset
                .asObservable(),
            frame: collectionViewFrame.asObserver()
        )
        .bind(to: imageControl.rx.currentPage)
        .disposed(by: disposeBag)
    }
    
    private func currentPage(offset: Observable<CGPoint>, frame: Observable<CGRect>) -> Observable<Int> {
        return Observable.combineLatest(offset,frame)
            .map{ Int($0.0.x) / Int($0.1.width)}
    }
    
    private func bindVariantsCollectionView() {
        variantsCollectionView.dataSource = nil
        variantsCollectionView.delegate = nil
        variantsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.variantsObservable
            .drive(variantsCollectionView.rx.items(cellIdentifier:  VariantsCollectionViewCell.reuseIdentifier(), cellType:  VariantsCollectionViewCell.self)) {indexPath, item, cell in
                cell.item = item
            }
            .disposed(by: disposeBag)
        viewModel.sendVariantsToCollection()
        viewModel.setInventoryQuantity()
        viewModel.setPriceForSelectedVariantIndex()
        
        variantsCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.indexSubject.onNext(indexPath.row)
                self?.viewModel.setInventoryQuantity()
                self?.viewModel.setPriceForSelectedVariantIndex()
            }).disposed(by: disposeBag)
    }
    private func bindColorsCollectionView() {
        colorsCollectionView.dataSource = nil
        colorsCollectionView.delegate = nil
        colorsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.colorsObservable
            .drive(colorsCollectionView.rx.items(cellIdentifier:  ColorsCollectionViewCell.reuseIdentifier(), cellType:  ColorsCollectionViewCell.self)) {indexPath, item, cell in
                cell.item = item
            }
            .disposed(by: disposeBag)
        viewModel.sendColorsToCollection()
    }
    
}

// MARK: - Extensions
extension ProductDetailsViewController  {
    // MARK: - Private handlers
    private func configure() {
        self.bindProductImagesCollectionView()
        self.bindPageController()
        self.bindCollectionViewToPageControll()
        self.addToFavourite()
        self.addToCartTapBinding()
        self.bindFavouriteButton()
        self.bindCloseButton()
        self.bindVariantsCollectionView()
        self.bindColorsCollectionView()
    }
}
// MARK: - Extensions
extension ProductDetailsViewController{
    // MARK: - Private handlers
    func bindFavouriteButton(){
        favoriteBtn.favouriteState(state: viewModel.isProductFavourite )
    }
    
    func addToFavourite(){
        favoriteBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else {return}
            self.handleFavouriteAction()
        }).disposed(by: disposeBag)
    }
    
    func handleFavouriteAction() {
        if viewModel.isLogged {
            if self.viewModel.toggleFavourite() {
                self.view.makeToast("Added to Favorites", duration: 3.0, position: .top)
                self.favoriteBtn.favouriteState(state:  true)
            }else{
                self.view.makeToast("Deleted from Favorites", duration: 3.0, position: .top)
                self.favoriteBtn.favouriteState(state:  false )
            }
            try! self.viewModel.modifyOrderInWishIfFavIdIsNil(self.viewModel.product, variant: self.viewModel.product.variants[self.viewModel.indexSubject.value()])
        }else{
            showNotLogedDialog()
        }
    }
    
    func showNotLogedDialog(){
        let dialogMessage = UIAlertController(title: "", message: "please login to add items to favourite", preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
// MARK: - Extensions
extension ProductDetailsViewController{
    // MARK: - Private handlers
    private func addToCartTapBinding(){
        addToCart.rx.tap.subscribe { [weak self] _ in
            guard let self = self else { return }
            if(try! self.viewModel.product.variants[self.viewModel.indexSubject.value()].inventoryQuantity != 0) {
                self.view.makeToast("Added to Cart", duration: 3.0, position: .bottom)
                try! self.viewModel.modifyOrderInCartIfCartIdIsNil(self.viewModel.product, variant: self.viewModel.product.variants[self.viewModel.indexSubject.value()])
            } else {
                self.view.makeToast("Sorry this item is out of stock", duration: 3.0, position: .bottom)
                
            }

        }.disposed(by: disposeBag)
    }
}
// MARK: - Extensions
extension ProductDetailsViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case productImagesCollectionView:
            return 0.0
        case variantsCollectionView:
            return 8.0
        case colorsCollectionView:
            return 8.0
        default:
            return 0.0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case productImagesCollectionView:
            return 0.0
        case variantsCollectionView:
            return 8.0
        case colorsCollectionView:
            return 8.0
        default:
            return 0.0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case productImagesCollectionView:
            return CGSize(width:productImagesCollectionView.frame.width, height: productImagesCollectionView.frame.height)
        case variantsCollectionView:
            return CGSize(width: (self.view.frame.width)/4, height: 28)
        case colorsCollectionView:
            return CGSize(width: (self.view.frame.width)/12, height: (self.view.frame.width)/12)
        default:
            return CGSize(width:productImagesCollectionView.frame.width, height: productImagesCollectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case productImagesCollectionView:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case variantsCollectionView:
            return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        case colorsCollectionView:
            return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

