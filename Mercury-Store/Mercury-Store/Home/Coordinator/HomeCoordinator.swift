//
//  HomeCoordinator.swift
//  Mercury-Store
//
//  Created by mac hub on 16/05/2022.
//

import UIKit

class HomeCoordinator : Coordinator {

    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let brandProvider: BrandsProvider = HomeScreenClient()
        let brandViewModel = BrandsViewModel(brandsProvider: brandProvider, homeFlowNavigation: self)
        let viewModel = HomeViewModel(with: self)
        let categoryViewModel = CategoriesViewModel(with: self)
        let homeVC = HomeViewController(with: viewModel, and: brandViewModel, categoryViewModel: categoryViewModel)
        navigationController.pushViewController(homeVC, animated: true)
    }
}

extension HomeCoordinator: HomeFlowNavigation {
    func goToFilteredProduct(with id: Int) {
        let viewModel = FilteredProductsViewModel(categoryID: id, productType: "", filteredProductsNavigationFlow: self)
        let productResultVC = ProductResultViewController(with: viewModel)
        navigationController.pushViewController(productResultVC, animated: true)
    }
    
    func goToBrandDetails(with brandItem: SmartCollectionElement) {
        let productsForBrandProvider =  HomeScreenClient()
        let viewModel = BrandDetailsViewModel(with: brandItem, productsForBrandProvider: productsForBrandProvider, brandDetailsNavigationFlow: self)
        let brandDetailsVC = BrandDetailViewController(with: viewModel)
        navigationController.pushViewController(brandDetailsVC, animated: true)
    }
    
    func goToSearchViewController() {
        let searchViewModel = ProductSearchViewModel(searchFlowNavigation: self)
        let searchVC = SearchViewController(with: searchViewModel)
        navigationController.pushViewController(searchVC, animated: true)
    }
}
extension HomeCoordinator: FilteredProductsNavigationFlow {
    func goToProductDetail(with product: Product) {
        let viewModel = ProductsDetailViewModel(with: self,product: product)
        let productDetailsVC = ProductDetailsViewController(with: viewModel)
        navigationController.pushViewController(productDetailsVC, animated: true)
    }
    
    func goToFilteredProductScreen() {
        
    }
}
extension HomeCoordinator: ProductDetailsNavigationFlow {
    
}

extension HomeCoordinator: BrandDetailsNavigationFlow {
    func goToProductDetails(with product: Product) {
        let viewModel = ProductsDetailViewModel(with: self,product: product)
        let productDetailsVC = ProductDetailsViewController(with: viewModel)
        navigationController.pushViewController(productDetailsVC, animated: true)
    }
    
    
}
extension HomeCoordinator: SearchFlowNavigation{
    func  goToProductDetailFromSearch(with item:Product){
        let viewModel = ProductsDetailViewModel(with: self,product: item)
        let productDetailsVC = ProductDetailsViewController(with: viewModel)
        navigationController.pushViewController(productDetailsVC, animated: true)
    }
}
