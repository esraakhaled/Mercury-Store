//
//  RadioButtonCell.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 14/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

enum paymentOptions{
    case withPaypal
    case cashOnDelivery
}
class RadioButtonCell: UITableViewCell {
    override var reuseIdentifier: String?{
        "RadioButtonCell"
    }
    @IBOutlet weak var payPal: UIButton!
    @IBOutlet weak var cashOnDelivery: UIButton!
    let disposeBage = DisposeBag()
    let paymentSubject = BehaviorSubject<paymentOptions>(value: .cashOnDelivery)
    override func awakeFromNib() {
        super.awakeFromNib()
        self.payPalAction()
        self.cashOnDeliveryAction()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
extension RadioButtonCell{
    
    private func payPalAction(){
        payPal.rx.tap.bind{ [ weak self ]  in
            guard let self = self else {return}
            self.cashOnDelivery.setImage(UIImage(systemName: "circle"), for: .normal)
            self.payPal.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
            self.paymentSubject.onNext(.withPaypal)
        }.disposed(by: disposeBage)
    }
    
    private func cashOnDeliveryAction(){
        cashOnDelivery.rx.tap.bind{ [ weak self ]  in
            guard let self = self else {return}
            self.payPal.setImage(UIImage(systemName: "circle") , for: .normal)
            self.cashOnDelivery.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
            self.paymentSubject.onNext(.cashOnDelivery)
        }.disposed(by: disposeBage)
    }
    
}
