//
//  ProfileViewController.swift
//  Mercury-Store
//
//  Created by mac hub on 16/05/2022.
//

import UIKit
import RxDataSources
import RxSwift

class ProfileViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: CurrencyTableViewCell.reuseIdentifier(), bundle: nil), forCellReuseIdentifier: CurrencyTableViewCell.reuseIdentifier())
        }
    }
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    
    // MARK: - Properties
    private var viewModel: ProfileViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - Set up
    init(with viewModel: ProfileViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        title = "Profile"
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        configureTableView()
        configureSectionModel()
        self.loadUserData()
        tableView.estimatedRowHeight = 80
    }
    private func setUpUI() {
        self.logoutBtn.tintColor = ColorsPalette.lightColor
        self.tableView.delegate = nil
        tableView.dataSource = nil
        tableView.rx.setDelegate(self)
    }
    
    // MARK: - IBActions
    @IBAction func logoutAction(_ sender: Any) {
        self.viewModel.goToMainTab()
    }
    // MARK: - Private handlers
    private func loadUserData(){
        let user = viewModel.getUserInfo()
        userName.text = user?.username
        userEmail.text = user?.email
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
        tableView.rx.itemSelected.subscribe(onNext: {[weak self] IndexPath in
            switch IndexPath.section{
            case 0:
                switch IndexPath.row {
                case 0:
                    self?.viewModel.goToMyOrdersScreen()
                case 1:
                    self?.viewModel.goToMyWishListScreen()
                case 2:
                    self?.viewModel.goToMyAddressesScreen()
                default:
                    break
                }
            case 1:
                self?.viewModel.goToAboutUsScreen()
                
            default:
                break
            }
            
            
        }).disposed(by: disposeBag)
    }
    func configureTableView() {
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
}

// MARK: - Extensions
extension ProfileViewController {
    
    static func dataSource() -> RxTableViewSectionedReloadDataSource<ProfileSectionModel> {
        return RxTableViewSectionedReloadDataSource<ProfileSectionModel>(
            configureCell: { dataSource, tableView, indexPath, item in
                switch dataSource[indexPath] {
                case let .myAccountItem(image: image,title: title):
                    let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
                    cell.selectionStyle = .none
                    cell.backgroundColor = .clear
                    cell.imageView?.tintColor = ColorsPalette.lightColor
                    cell.textLabel?.text = title
                    cell.imageView?.image = image
                    cell.accessoryType = .disclosureIndicator
                    return cell
                case let .aboutItem(image: image,title: title):
                    let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
                    cell.selectionStyle = .none
                    cell.backgroundColor = .clear
                    cell.imageView?.tintColor = ColorsPalette.lightColor
                    cell.textLabel?.text = title
                    cell.imageView?.image = image
                    cell.accessoryType = .disclosureIndicator
                    return cell
                case .currencyItem:
                    guard let currencyCell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.reuseIdentifier(), for: indexPath) as? CurrencyTableViewCell else {
                        fatalError("Couldn't dequeue logo cell")
                    }
                    
                    return currencyCell
                }
            }, titleForHeaderInSection: { dataSource, index in
                let section = dataSource[index]
                return section.title
            })
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
