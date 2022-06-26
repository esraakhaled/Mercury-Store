//
//  CheckAddressesTableViewCell.swift
//  Mercury-Store
//
//  Created by mac hub on 22/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

class CheckAddressesTableViewCell: UITableViewCell {
    // MARK: - Outlets
    //
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    
    
    // MARK: - Properties
    //
    private(set) var disposeBag = DisposeBag()
    var deleteTap: ControlEvent<Void> { self.deleteButton.rx.tap }
    var editTap: ControlEvent<Void> {self.editButton.rx.tap }
    var address: CustomerAddress? {
        didSet {
            guard let address = address else {
                return
            }
            addressLabel.text = address.address1
            cityLabel.text = address.city
            countryLabel.text = address.countryName
        }
    }
    // MARK: - Life cycle
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    private func setUpUI() {
        self.editButton.tintColor = ColorsPalette.lightColor
    }
    
}
