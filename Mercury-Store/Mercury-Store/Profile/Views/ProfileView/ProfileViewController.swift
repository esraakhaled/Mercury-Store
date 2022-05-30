//
//  ProfileViewController.swift
//  Mercury-Store
//
//  Created by mac hub on 16/05/2022.
//

import UIKit
import RxDataSources
import RxSwift

class ProfileViewController: UIViewController, ProfileCoordinated{
    
    var coordinator: ProfileBaseCoordinator?
    var viewModel: ProfileViewModel!
    let disposeBag = DisposeBag()
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userEmail: UILabel!
    
    init(coordinator: ProfileBaseCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
        title = "Profile"
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // view.backgroundColor = .lightGray
        configureTableView()
        configureViewModel()
        configureSectionModel()
        
       // self.tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "cell")

    }
    private func configureViewModel() {
       viewModel = ProfileViewModel()
    }

    @IBAction func didPressedOnCartButton(_ sender: Any) {
        
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        coordinator?.moveTo(flow: .home(.intialScreen), userData: nil)
    }
    private func configureSectionModel() {
        // 1
        viewModel.configureSectionModel()
        // 2
        let dataSource =  ProfileViewController.dataSource()
        // 3
        viewModel
            .sectionModels
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // 4
        /*tableView.rx.modelSelected(ProfileSectionItem.self)
            .asDriver()
            .drive(onNext: { [weak self] model in
                switch model {
                case .aboutItem(image: let image, title: let title):
                    //self?.presentAlert( message: title)
                
                default: break
                }
            }).disposed(by: disposeBag)*/
        tableView.rx.itemSelected.subscribe(onNext: { IndexPath in
            switch IndexPath.section{
            case 0:
                switch IndexPath.row {
                case 0:
                    self.coordinator?.moveTo(flow: .profile(.myOrdersScreen), userData: nil)
                case 1:
                    self.coordinator?.moveTo(flow: .profile(.myWishlistScreen), userData: nil)
                default:
                    self.coordinator?.moveTo(flow: .profile(.myAddressesScreen), userData: nil)

               

                }
            default:
                self.coordinator?.moveTo(flow: .profile(.aboutScreen), userData: nil)
                
            }
           
            
        }).disposed(by: disposeBag)
    }
    func configureTableView() {
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "cell")
       // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
  /*  private func presentAlert( message: String) {
        let alert = UIAlertController(title: "\(title) Selected", message: "It cost you \(message)", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    */
}
extension ProfileViewController {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<ProfileSectionModel> {
        return RxTableViewSectionedReloadDataSource<ProfileSectionModel>(
            configureCell: { dataSource, tableView, indexPath, _ in
               // let cell: ProfileCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileCell
            switch dataSource[indexPath] {
            case let .myAccountItem(image: image,title: title):
                let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
                     cell.selectionStyle = .none
                     cell.backgroundColor = .clear
                cell.imageView?.tintColor = .label
                     cell.textLabel?.text = title
                     cell.imageView?.image = image
                     cell.accessoryType = .disclosureIndicator
                    return cell
            case let .aboutItem(image: image,title: title):
                let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.imageView?.tintColor = .label
                cell.textLabel?.text = title
                cell.imageView?.image = image
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        }, titleForHeaderInSection: { dataSource, index in
            let section = dataSource[index]
            return section.title
        })
    }
}