//
//  AddressTVCell.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 21/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

class AddressTVCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var edit: UIImageView!
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
        }
    }
    // MARK: - Life cycle
    //
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    

    
}

