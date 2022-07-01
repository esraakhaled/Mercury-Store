//
//  CurrencyTableViewCell.swift
//  Mercury-Store
//
//  Created by mac hub on 29/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

class CurrencyTableViewCell: UITableViewCell {
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!
    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var currencyLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        preSelectIndex()
        bindSegmentedControl()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.currencyImageView?.tintColor = ColorsPalette.lightColor
    }
    private func preSelectIndex() {
        let currentCurrency = UserDefaults.standard.string(forKey: "currency")
        guard let currentCurrency = currentCurrency else {
            return
        }
        if(currentCurrency == "EGP") {
            self.currencySegmentedControl.selectedSegmentIndex = 0
        }else {
            self.currencySegmentedControl.selectedSegmentIndex = 1
        }
    }
    private func bindSegmentedControl() {
        self.currencySegmentedControl.rx.value
            .subscribe (onNext: {[weak self] currentIndex in
                guard let `self` = self else {return}
                let currentTitle = self.currencySegmentedControl.titleForSegment(at: currentIndex)
                guard let currentTitle = currentTitle else {
                    return
                }
                self.setCurrencyInUserDefaults(currentTitle)
            }).disposed(by: disposeBag)
    }
    
    private func setCurrencyInUserDefaults(_ currency: String) {
        UserDefaults.standard.set(currency, forKey: "currency")
    }
    
}
