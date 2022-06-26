//
//  OrderDetailsCell.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 23/05/2022.
//

import UIKit

class OrderDetailsCell: UITableViewCell {
    @IBOutlet weak var orderName: UILabel!
    
    @IBOutlet weak var orderPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
