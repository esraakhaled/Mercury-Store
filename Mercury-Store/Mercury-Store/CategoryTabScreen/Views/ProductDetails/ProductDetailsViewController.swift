//
//  ProductDetailsViewController.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 29/05/2022.
//

import UIKit
import RxSwift
import Kingfisher
class ProductDetailsViewController: UIViewController ,CategoryBaseCoordinated{
   
    
    var coordinator: CategoryBaseCoordinator?
   // var product :Variant?
   // var product : Product?
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var imageControl: UIPageControl!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var productDetailsCollectionView: UICollectionView!
    @IBOutlet weak var favoriteBtn: UIButton!
    private let disposeBag = DisposeBag()
    private var ProductID:Int?
    var item:Product?
  //  var viewModel:ProductsDetailsViewModelType?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    init(coordinator: CategoryBaseCoordinator ,product: [String:Any] ) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
       // self.product = product["product"] as! Product
        //title = self.product?.title
       // let product:Product = product["product"]
       // productTitleLabel.text = product.title
       // productPriceLabel.text = product.price
        let product:Product = product["product"] as! Product
        title = "\(product.title) Products"
       // self.viewModel = ProductsDetailsViewModel(productID: product.id)
        print(product)
    }
    public func configure(item:Product){
       // ImageDownloaderHelper.imageDownloadHelper(imageControl, item.image.src)
        productTitleLabel.text = "\(item.title)"
        productPriceLabel.text = "\(item.variants[0].price)EGP"
        //self.item = item
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @IBAction func addToCartBtn(_ sender: Any) {
    }
   /* private func setupImageCollection(){
        productDetailsCollectionView.dataSource = self
        productDetailsCollectionView.delegate = self
        productDetailsCollectionView.register(ProductDetailsImageCollectionCell.nib(), forCellWithReuseIdentifier: ProductDetailsImageCollectionCell.identifier)
    }*/
    
}

/*extension ProductDetailsViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let product = product,let images = product.images else{return 0}
        imageControl.numberOfPages = images.count
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let productDetailsCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailsImageCollectionCell.identifier, for: indexPath) as! ProductDetailsImageCollectionCell
        guard let product = product,let images = product.images else{return UICollectionViewCell()}
        productDetailsCell.productImageDetails.kf.setImage(with: URL(string: images[indexPath.row].src ?? "test"), placeholder: UIImage(named: "test"))
        return productDetailsCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        imageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }*/
    

