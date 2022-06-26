//
//  BannerTableViewCell.swift
//  Mercury-Store
//
//  Created by mac hub on 17/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

class BannerTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    //
    @IBOutlet weak private var containerViewForBannerCollectionView: UIView!
    @IBOutlet weak private var bannerCollectionView: UICollectionView! {
        didSet {
            bannerCollectionView.register(UINib(nibName: BannerCollectionViewCell.reuseIdentifier(), bundle: nil), forCellWithReuseIdentifier: BannerCollectionViewCell.reuseIdentifier())
        }
    }
    @IBOutlet weak private var bannerImageViewPageControl: UIPageControl!
    // MARK: - Properties
    //
    private let disposeBag = DisposeBag()
    
    private let collectionViewFrame = ReplaySubject<CGRect>.create(bufferSize: 1)
    
    var viewModel: BannerViewModel? {
        didSet {
            self.configure()
        }
    }
    
    // MARK: - Life cycle
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
        collectionViewFrame.onNext(self.bannerCollectionView.frame)
    }
    
    private func setupCell() {
        self.contentView.applyShadow(cornerRadius: 8)
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.masksToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
// MARK: - Extensions
extension BannerTableViewCell {
    // MARK: - Private handlers
    //
    private func bindCollectionView() {
        bannerCollectionView.dataSource = nil
        bannerCollectionView.delegate = nil
        bannerCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel?.pricesRules
            .drive(bannerCollectionView.rx.items(cellIdentifier: BannerCollectionViewCell.reuseIdentifier(), cellType: BannerCollectionViewCell.self)) {indexPath, item , cell in
                cell.item = item
                cell.index = indexPath
            }
            .disposed(by: disposeBag)
    }
    
    private func bindPageController() {
        viewModel?.countForPageControll.asObservable()
            .bind(to: bannerImageViewPageControl.rx.numberOfPages)
            .disposed(by: disposeBag)
    }
    
    private func bindCollectionViewToPageControll() {
        currentPage(
            offset: bannerCollectionView.rx.contentOffset
                .asObservable(),
            frame: collectionViewFrame.asObserver()
        )
        .bind(to: bannerImageViewPageControl.rx.currentPage)
        .disposed(by: disposeBag)
    }
        
    private func currentPage(offset: Observable<CGPoint>, frame: Observable<CGRect>) -> Observable<Int> {
        return Observable.combineLatest(offset,frame)
            .map{ Int($0.0.x) / Int($0.1.width)}
            
    }
}
// MARK: - Extensions
extension BannerTableViewCell {
    // MARK: - Private handlers
    //
    private func configure() {
        self.bindCollectionView()
        self.bindPageController()
        self.bindCollectionViewToPageControll()
    }
}
// MARK: - Extensions
extension BannerTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bannerCollectionView.frame.width, height: bannerCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}



