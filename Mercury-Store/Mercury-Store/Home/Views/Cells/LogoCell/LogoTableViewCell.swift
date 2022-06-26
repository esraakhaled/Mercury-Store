//
//  LogoTableViewCell.swift
//  Mercury-Store
//
//  Created by mac hub on 17/05/2022.
//

import UIKit
import RxSwift

class LogoTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //
    @IBOutlet weak private var  logoImageView: UIImageView!
    @IBOutlet weak private var  containerViewForLogoImageView: UIView!
    // MARK: - Properties
    //
    var logoImageName: String? {
        didSet {
            logoImageView.image = UIImage(named: logoImageName!)
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
}




