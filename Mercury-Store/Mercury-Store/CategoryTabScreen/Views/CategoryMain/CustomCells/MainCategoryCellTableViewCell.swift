//
//  MainCategoryCellTableViewCell.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 01/06/2022.
//

import UIKit

class MainCategoryCellTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    //
    @IBOutlet weak var cellContainerView: UIView!
    @IBOutlet weak var categoryItem: UILabel!
    // MARK: - Properties
    //
    static let identifier = "MainCategoryCellTableViewCell"
    var item:CustomCollection?
    var cellClickAction:( (_ item:CustomCollection)->() )?
    // MARK: - Life cycle
    //
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        designSelected(selected: selected)
    }
    
    func designSelected(selected:Bool){
        if selected {
            self.categoryItem.textColor = .white
            self.cellContainerView.backgroundColor = ColorsPalette.lightColor
        }
        else{
            self.categoryItem.textColor = .black
            self.cellContainerView.backgroundColor = .white
        }
    }
    // MARK: - Private handlers
    //
    public func config(item:CustomCollection){
        self.item = item
        categoryItem.text = item.title
    }
}
