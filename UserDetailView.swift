//
//  UserDetailView.swift
//  iOSLearningApp
//
//  Created by Ritik Raj on 23/09/22.
//

import Foundation
import UIKit
import SnapKit

class userDetailViewController: UIViewController {
    private let Constantitems = ConstantItems.items
    private let tableView = UITableView()
    private let header = UILabel()
    private let spinner = UIActivityIndicatorView()
    private let loadingLabel = UILabel()
    private let loadingView = UIView()
    var details: UserDetail?
    var u_login: String?
    let UserViewModel =  UserDetailsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        UserViewModel.u_login = u_login ?? ""
        self.showLoader()
        UserViewModel.delegate=self
        self.UserViewModel.fetchData()
    }
    func configure(){
        view.addSubview(header)
        header.text = Constantitems[6]
        header.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        header.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        tableView.backgroundColor = .white
        tableView.register(CustomUserTableViewCell.self, forCellReuseIdentifier: Constantitems[7])
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints{make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(header.snp.bottom)
        }
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
}
extension userDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constantitems[7]) as! CustomUserTableViewCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
        let index = indexPath.row - 1
        cell.setData(data: self.details, index: index)
        return cell
    }
}
extension userDetailViewController: userDetailViewControllerProtocol {
    func dataLoaded() {
        details = UserViewModel.details
        self.configure()
        self.tableView.reloadData()
    }
    func hideLoader(){
        loadingView.removeFromSuperview()
    }
}
protocol userDetailViewControllerProtocol: AnyObject {
    func dataLoaded()
    func hideLoader()
}
