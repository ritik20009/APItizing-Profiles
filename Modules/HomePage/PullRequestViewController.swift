//
//  ViewController.swift
//  iOSLearningApp
//
//  Created by Ritik Rj on 14/09/22.
//

import UIKit
import SnapKit

final class PullRequestViewController: UIViewController, UITableViewDelegate {
    
    private let viewModel = PullRequestViewModel()
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private let spinner = UIActivityIndicatorView()
    private let loadingLabel = UILabel()
    private let loadingView = UIView()
    
    private var response: SampleResponse?
    private var userLogin: String?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(ErrorDescription.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        showLoader()
        viewModel.delegate = self
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.black
        
        let reloadTable: (Notification)->Void = {make in
            self.tableView.reloadData()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(NotificationCenterKeywords.observer), object: nil, queue: nil, using: reloadTable)
        
        self.viewModel.fetchData()
    }
    
    private func configure() {
        self.configureView()
        self.configureTitleLabel()
        self.configureTableView()
    }

    private func configureView() {
        self.view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }
    
    private func configureTitleLabel() {
        titleLabel.text = ConstantItems.homePageHeading
        titleLabel.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(NumberConstants.fifty)
            make.left.equalToSuperview().offset(175)
        }
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.separatorColor = .white
        tableView.register(PullRequestTableViewCell.self, forCellReuseIdentifier: PullRequestTableViewCell.description())
        tableView.register(LoaderViewCell.self, forCellReuseIdentifier: LoaderViewCell.description())
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.snp.makeConstraints{make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    private func configureLoadingLabel() {
        loadingLabel.text = ConstantItems.loading
        loadingLabel.font = UIFont.systemFont(ofSize: CGFloat(NumberConstants.twenty), weight: .bold)
        loadingLabel.snp.makeConstraints{make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(spinner.snp.right).offset(NumberConstants.thirty)
        }
    }
    
    private func configureLoadingView() {
        loadingView.backgroundColor = .white
        loadingView.addSubview(loadingLabel)
        loadingView.addSubview(spinner)
        loadingView.snp.makeConstraints{make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func configureSpinner() {
        spinner.transform = CGAffineTransform(scaleX: 3, y: 3)
        spinner.snp.makeConstraints{make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
        }
        spinner.startAnimating()
    }
    
    private func showLoader() {
        view.backgroundColor = .white
        view.addSubview(loadingView)
        configureLoadingView()
        configureLoadingLabel()
        configureSpinner()
    }
}

extension PullRequestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = response?.items?.count else{ return 0 }
        return count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableSize = self.response?.items?.count else {
            return UITableViewCell()
        }
        if(indexPath.row == tableSize){
            let cell = tableView.dequeueReusableCell(withIdentifier: LoaderViewCell.description()) as! LoaderViewCell
            cell.showLoader()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PullRequestTableViewCell.description()) as! PullRequestTableViewCell
            self.userLogin = cell.setData(data: self.response?.items?[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableSize = self.response?.items?.count else { return }
        viewModel.showNext(indexPath: indexPath, tableSize: tableSize)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetailsViewController = UserDetailViewController()
        userLogin = (response?.items?[indexPath.row].user?.login)!
        userDetailsViewController.u_login = userLogin ?? ""
        self.navigationController?.pushViewController(userDetailsViewController, animated: true)
    }
}

extension PullRequestViewController: ViewControllerProtocol {
    func dataLoaded() {
        response = viewModel.response
        self.tableView.reloadData()
    }
    
    func hideLoader() {
        loadingView.removeFromSuperview()
    }
}

protocol ViewControllerProtocol: AnyObject {
    func dataLoaded()
    func hideLoader()
}
