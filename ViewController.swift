//
//  ViewController.swift
//  iOSLearningApp
//
//  Created by Ritik Rj on 14/09/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDelegate {
    private let viewModel = HomePageViewModel()
    let loading = loadingData()
    private let Constantitems = ConstantItems.items
    private struct Constants {
        static let spinnerSize: CGSize = .zero
    }
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private let spinner = UIActivityIndicatorView()
    private let loadingLabel = UILabel()
    private let loadingView = UIView()
    var response: SampleResponse?
    var user_login: String?
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        showLoader()
        viewModel.delegate = self
        self.viewModel.fetchData()
    }
    func showLoader() {
        view.backgroundColor = .white
        view.addSubview(loadingView)
        loadingView.backgroundColor = .white
        loadingView.snp.makeConstraints{make in
            make.centerX.centerY.equalToSuperview()
        }
        loadingLabel.text = Constantitems[1]
        loadingView.addSubview(loadingLabel)
        loadingLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        loadingView.addSubview(spinner)
        spinner.transform = CGAffineTransform(scaleX: 3, y: 3)
        spinner.snp.makeConstraints{make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
        }
        loadingLabel.snp.makeConstraints{make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(spinner.snp.right).offset(30)
        }
        spinner.startAnimating()
    }
    func configure(){
        self.view.backgroundColor = .white
        titleLabel.text = Constantitems[2]
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(50)
            make.left.equalToSuperview().offset(175)
        }
        tableView.backgroundColor = .white
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: Constantitems[3])
        tableView.register(loadingData.self, forCellReuseIdentifier: Constantitems[4])
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints{make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (response?.items?.count ?? 0)! + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableSize = self.response?.items?.count else {
            return UITableViewCell()
        }
        if(indexPath.row==tableSize){
            let cell = tableView.dequeueReusableCell(withIdentifier: Constantitems[4]) as! loadingData
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
            cell.showLoader()
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Constantitems[3]) as! CustomTableViewCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
            self.user_login = cell.setData(data: self.response?.items?[indexPath.row])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableSize = self.response?.items?.count else {
            return
        }
        if(indexPath.row == tableSize - 2){
            loading.showLoader()
            viewModel.delegate = self
            self.viewModel.fetchData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetailsViewController = userDetailViewController()
        user_login = (response?.items?[indexPath.row].user?.login)!
        userDetailsViewController.u_login = user_login ?? ""
        self.navigationController?.pushViewController(userDetailsViewController, animated: true)
    }
}
extension ViewController: ViewControllerProtocol {
    func dataLoaded() {
        response = viewModel.response
        self.tableView.reloadData()
    }
    func hideLoader(){
        loadingView.removeFromSuperview()
    }
}
protocol ViewControllerProtocol: AnyObject {
    func dataLoaded()
    func hideLoader()
}
