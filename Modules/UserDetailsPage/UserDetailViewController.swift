//
//  UserDetailView.swift
//  iOSLearningApp
//
//  Created by Ritik Raj on 23/09/22.
//

import Foundation
import UIKit
import SnapKit

final class UserDetailViewController: UIViewController {
    
    
    private let tableView = UITableView()
    private let header = UILabel()
    private let spinner = UIActivityIndicatorView()
    private let loadingLabel = UILabel()
    private let loadingView = UIView()
    private let FavouriteButton = UIBarButtonItem()
    private let DownloadButton = UIBarButtonItem()
    private let UserViewModel =  UserDetailsViewModel()
    private var details: UserDetail?
    var u_login: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        UserViewModel.u_login = u_login
        UserViewModel.delegate = self
        if UserDefaults.standard.object(forKey: u_login) == nil{
            self.showLoader()
        }
        self.showSaveButton()
        self.showFavouriteButton()
        self.UserViewModel.fetchData()
    }

    private func configure() {
        self.configureView()
        self.configureTableView()
        self.configureHeader()
        self.navigationItem.rightBarButtonItems = [DownloadButton, FavouriteButton]
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.separatorColor = .white
        tableView.register(UserDetailsTableViewCell.self, forCellReuseIdentifier: UserDetailsTableViewCell.description())
        tableView.dataSource = self
        tableView.snp.makeConstraints{make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(header.snp.bottom)
        }
    }
    
    private func configureHeader() {
        header.text = ConstantItems.userTableHeading
        header.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        header.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
    }
    
    private func configureView() {
        view.addSubview(header)
        view.addSubview(tableView)
    }
    
    private func configureLoadingLabel() {
        loadingLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        loadingLabel.text = ConstantItems.loading
        loadingLabel.snp.makeConstraints{make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(spinner.snp.right).offset(30)
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
    
    private func showSaveButton() {
        DownloadButton.style = .plain
        DownloadButton.target = self
        DownloadButton.action = #selector(saveButtonAction)
    }
    
    private func deleteButton() {
        DownloadButton.style = .plain
        DownloadButton.target = self
        DownloadButton.action = #selector(deleteButtonAction)
    }
    
    private func showFavouriteButton() {
        FavouriteButton.style = .plain
        FavouriteButton.target = self
        FavouriteButton.action = #selector(favouriteButtonAction)
    }
    
    @objc func favouriteButtonAction() {

        let data: String = ""
        if UserDefaults.standard.object(forKey: Utils.shared.getKeyForFavourite(userName: u_login)) == nil {
            UserDefaults.standard.set(data, forKey: Utils.shared.getKeyForFavourite(userName: u_login))
            FavouriteButton.image = UIImage(systemName: ButtonSymbols.fillStar)
        } else {
            UserDefaults.standard.removeObject(forKey: Utils.shared.getKeyForFavourite(userName: u_login))
            FavouriteButton.image = UIImage(systemName: ButtonSymbols.star)
        }
        NotificationCenter.default.post(name: NSNotification.Name(NotificationCenterKeywords.observer), object: nil)
    }
    
    @objc func saveButtonAction() {
        
        guard let encodedData = try? JSONEncoder().encode(details) else { return }
        guard let jsonString = String(data: encodedData, encoding: .utf8) else { return }
        
        if UserDefaults.standard.object(forKey: u_login) == nil{
            UserDefaults.standard.set(jsonString, forKey: u_login)
            DownloadButton.image = UIImage(systemName: ButtonSymbols.deleteButton)
            let dialogMessage = UIAlertController(title: ButtonActionConstants.saved, message: ButtonActionConstants.savedConfirmation, preferredStyle: .alert)
            
            self.present(dialogMessage, animated: true, completion: nil)
            
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when){
              dialogMessage.dismiss(animated: true, completion: nil)
            }
        } else {
            deleteButtonAction()
        }
        
    }
    
    @objc func deleteButtonAction(){
        if UserDefaults.standard.object(forKey: u_login) == nil{
            return
        } else {
            let dialogMessage = UIAlertController(title: ButtonActionConstants.confirm, message: ButtonActionConstants.askConfirmation, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: ButtonActionConstants.ok, style: .destructive, handler: {(action) -> Void in
                        UserDefaults.standard.removeObject(forKey: self.u_login)
                        self.DownloadButton.image = UIImage(systemName: ButtonSymbols.downloadButton)
                
            let alerting = UIAlertController(title: ButtonActionConstants.deleted, message: ButtonActionConstants.deletedConfirmation, preferredStyle: .alert)
                
            self.present(alerting, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when){
                    alerting.dismiss(animated: true, completion: nil)
                }
            })
            let cancel = UIAlertAction(title: ButtonActionConstants.cancel, style: .cancel) {(action) -> Void in
                return
            }
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
}

extension UserDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailsTableViewCell.description()) as! UserDetailsTableViewCell
        let index = indexPath.row - 1
        cell.setData(data: self.details, index: index)
        return cell
    }
}

extension UserDetailViewController: userDetailViewControllerProtocol {
    func dataLoaded() {
        details = UserViewModel.details
        self.configure()
        self.tableView.reloadData()
    }
    
    func hideLoader(){
        loadingView.removeFromSuperview()
    }
    
    func setFavouriteState(isFavourite: Bool) {
        if !isFavourite {
            FavouriteButton.image = UIImage(systemName: ButtonSymbols.star)
        } else {
            FavouriteButton.image = UIImage(systemName: ButtonSymbols.fillStar)
        }
    }
    
    func setDownloadState(isDownloaded: Bool) {
        if !isDownloaded {
            DownloadButton.image = UIImage(systemName: ButtonSymbols.downloadButton)
        } else {
            DownloadButton.image = UIImage(systemName: ButtonSymbols.deleteButton)
        }
    }
}

protocol userDetailViewControllerProtocol: AnyObject {
    func dataLoaded()
    func hideLoader()
    func setFavouriteState(isFavourite: Bool)
    func setDownloadState(isDownloaded: Bool)
}
