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

class CategoryViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = CategoriesScreenViewModel()
    //just to push
    @IBOutlet weak var mainCategoryItems: UITableView!
    let cateBackgroundIMG : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named:"categories_background")
        iv.contentMode = .scaleAspectFill
        iv.alpha = 0.5
        return iv
    }()
    
    @IBOutlet var categoriesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        initTableView()
    }
    
}

extension CategoryViewController :UITableViewDelegate{
    func initTableView(){
        let nib = UINib(nibName: "MainCategoryCellTableViewCell", bundle: nil)
        mainCategoryItems.separatorStyle = .none
        mainCategoryItems.register(nib, forCellReuseIdentifier: MainCategoryCellTableViewCell.identifier)
        mainCategoryItems.delegate = self
        setupReactiveMainCategoryTableData()
    }
    func deselectAllRows(selectedIndex:Int ,animated: Bool) {
        for index in 0 ... mainCategoryItems.numberOfRows(inSection: 0)-1{
            let indexPath = IndexPath(row: index, section: 0)
            if(index != selectedIndex){
                let cell = mainCategoryItems.cellForRow(at: indexPath) as? MainCategoryCellTableViewCell
                cell?.cellContainerView.backgroundColor = .white
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.deselectAllRows( selectedIndex : indexPath.row ,animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! MainCategoryCellTableViewCell
        cell.cellContainerView.backgroundColor = .blue
        cell.isSelected = true
        viewModel.categoryDetails.categoryID = cell.item?.id ?? 0
    }
    func setupReactiveMainCategoryTableData(){
        viewModel.categories.drive(mainCategoryItems.rx.items(cellIdentifier: MainCategoryCellTableViewCell.identifier, cellType: MainCategoryCellTableViewCell.self)){ index , element , cell in
            cell.config(item: element)
        }.disposed(by: disposeBag)
    }
}
extension CategoryViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let padding: CGFloat =  20
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: 200)
    }
    
    func setupCollection(){
        let nib = UINib(nibName: "CategoryItem", bundle: nil)
        categoriesCollectionView.register(nib, forCellWithReuseIdentifier: CategoryItem.identifier)
        viewModel.categoryDetails.productTypes.drive(categoriesCollectionView.rx.items(cellIdentifier: CategoryItem.identifier, cellType: CategoryItem.self)){ index , element , cell in
            cell.config(name: element , itemId: self.viewModel.categoryDetails.categoryID)
            cell.cellClickAction =  { (id, type) in
//                self.coordinator?.moveTo(flow: .category(.productsScreen), userData: ["collection":id , "type": type])
            }
        }.disposed(by: disposeBag)
        categoriesCollectionView.delegate = self
        categoriesCollectionView.backgroundView = cateBackgroundIMG
    }
}
