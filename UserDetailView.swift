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
    
    
    let tableView = UITableView()
    
    let header = UILabel()
    
    var spinner = UIActivityIndicatorView()
    var loadingLabel = UILabel()
    var loadingView = UIView()
    
    var details: UserDetail?
    
    var str: String?
    var u_login: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        view.backgroundColor = .white
        
        let success: (_ res:UserDetail) -> ()  = {(res)-> Void in
            self.details = res
            self.configure()
            self.tableView.reloadData()
            self.hideLoader()
        }

        let showError: () -> ()  = {()-> Void in
            print("Inside error handler")
        }

        let file = FileManager()
        self.showLoader()
        var url = "https://api.github.com/users/"
        url = url+(u_login ?? "")
        file.fetchResponse(apiUrl: url, success: success, failure: showError)
        
    }
    
    func configure(){
        
        view.addSubview(header)
        header.text = "User Details"
        header.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        
        header.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        
        tableView.backgroundColor = .white
        tableView.register(CustomeUserTableViewCell.self, forCellReuseIdentifier: "CustomeUserTableViewCell")
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
        loadingLabel.text = "Loading..."
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
    
    func hideLoader(){
        loadingView.removeFromSuperview()
    }
    
}

extension userDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomeUserTableViewCell") as! CustomeUserTableViewCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
        let index = indexPath.row - 1
        cell.setData(data: self.details, index: index)
        return cell
    }
}
