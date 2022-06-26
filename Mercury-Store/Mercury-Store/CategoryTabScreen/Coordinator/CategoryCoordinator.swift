//
//  CategoryCoordinator.swift
//  Mercury-Store
//
//  Created by mac hub on 16/05/2022.
//

import UIKit

class CategoryCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
        
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let categoriesViewModel = CategoriesScreenViewModel(with: self)
        let categoriesVC = CategoryViewController(with: categoriesViewModel)
        navigationController.pushViewController(categoriesVC, animated: true)
    }
}

extension CategoryCoordinator: CategoriesNavigationFlow {
    func gotToProductScreen(with id: Int, type: String) {
        let viewModel = FilteredProductsViewModel(categoryID: id, productType: type, filteredProductsNavigationFlow: self)
        let productResultVC = ProductResultViewController(with: viewModel)
        navigationController.pushViewController(productResultVC, animated: true)
    }
}


extension CategoryCoordinator: FilteredProductsNavigationFlow {
    func goToSearchScreen() {
        let searchViewModel = ProductSearchViewModel(searchFlowNavigation: self)
        let searchVC = SearchViewController(with: searchViewModel)
        navigationController.pushViewController(searchVC, animated: true)
    }
    
    func goToProductDetail(with product: Product) {
        let viewModel = ProductsDetailViewModel(with: self,product: product)
        let productDetailsVC = ProductDetailsViewController(with: viewModel)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(productDetailsVC, animated: true)
    }

    func goToFilteredProductScreen() {
        
    }
}

extension CategoryCoordinator: ProductDetailsNavigationFlow {
    func popViewController() {
        navigationController.popViewController(animated: true)
        navigationController.setNavigationBarHidden(false, animated: false)
    }
    
    
}

extension CategoryCoordinator: SearchFlowNavigation {
    func  goToProductDetailFromSearch(with item:Product){
        let viewModel = ProductsDetailViewModel(with: self,product: item)
        let productDetailsVC = ProductDetailsViewController(with: viewModel)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(productDetailsVC, animated: true)
    }
}
