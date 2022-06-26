//
//  FilterViewController.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 26/05/2022.
//

import UIKit

class FilterViewController: UIViewController {
    // MARK: - Life cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Set up
    //
    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "Filter Products"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
