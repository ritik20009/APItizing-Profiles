//
//  UserDetailView.swift
//  iOSLearningApp
//
//  Created by Ritik Raj on 23/09/22.
//

import Foundation
import UIKit
import SnapKit

class UserDetailViewController: UIViewController {
    private let Constantitems = ConstantItems.items
    private let tableView = UITableView()
    private let header = UILabel()
    private let spinner = UIActivityIndicatorView()
    private let loadingLabel = UILabel()
    private let loadingView = UIView()
    private var FavouriteButton = UIBarButtonItem()
    private var DownloadButton = UIBarButtonItem()
    

    var details: UserDetail?
    var u_login: String = ""
    let UserViewModel =  UserDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        UserViewModel.u_login = u_login
        self.showLoader()
        UserViewModel.delegate=self
        self.showSaveButton()
        self.showFavouriteButton()
        if UserDefaults.standard.object(forKey: "favourite\(String(describing: u_login))")==nil{
            FavouriteButton.image = UIImage(systemName: ButtonSymbols.star)
        }
        else{
            FavouriteButton.image = UIImage(systemName: ButtonSymbols.fillStar)
        }
        if UserDefaults.standard.object(forKey: u_login )==nil{
            DownloadButton.image = UIImage(systemName: ButtonSymbols.downloadButton)
        }
        else{
            DownloadButton.image = UIImage(systemName: ButtonSymbols.deleteButton)
        }
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
        self.navigationItem.rightBarButtonItems = [DownloadButton,FavouriteButton]
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
    
    func showSaveButton() {
        DownloadButton.style = .plain
        DownloadButton.target = self
        DownloadButton.action = #selector(saveButtonAction)
    }
    func deleteButton(){
        DownloadButton.style = .plain
        DownloadButton.target = self
        DownloadButton.action = #selector(deleteButtonAction)
    }
    func showFavouriteButton() {
        FavouriteButton.style = .plain
        FavouriteButton.target = self
        FavouriteButton.action = #selector(favouriteButtonAction)
    }
    
    @objc func favouriteButtonAction(){
        
        let data: String = ""
        if UserDefaults.standard.object(forKey: "favourite\(u_login)")==nil {
            UserDefaults.standard.set(data, forKey: "favourite\(u_login)")
            FavouriteButton.image = UIImage(systemName: ButtonSymbols.fillStar)
        }
        else{
            UserDefaults.standard.removeObject(forKey: "favourite\(u_login)")
            FavouriteButton.image = UIImage(systemName: ButtonSymbols.star)
        }
        NotificationCenter.default.post(name: NSNotification.Name("observer"), object: nil)
    }
    @objc func saveButtonAction(){
        
        guard let encodedData = try? JSONEncoder().encode(details) else { return }
        guard let jsonString = String(data: encodedData, encoding: .utf8) else{
            return
        }
        
        if UserDefaults.standard.object(forKey: u_login )==nil{
            UserDefaults.standard.set(jsonString, forKey: u_login)
            DownloadButton.image = UIImage(systemName: ButtonSymbols.deleteButton)
            let dialogMessage = UIAlertController(title: "Saved", message: "Data has been saved successfully", preferredStyle: .alert)
            self.present(dialogMessage, animated: true, completion: nil)
            
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
              dialogMessage.dismiss(animated: true, completion: nil)
            }
        }
        else{
            deleteButtonAction()
        }
        
    }
    @objc func deleteButtonAction(){
        if UserDefaults.standard.object(forKey: u_login )==nil{
            return
        }
        else{
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        UserDefaults.standard.removeObject(forKey: self.u_login)
                        self.DownloadButton.image = UIImage(systemName: ButtonSymbols.downloadButton)
                        let alerting = UIAlertController(title: "Deleted", message: "Data has been deleted successfully", preferredStyle: .alert)
                        self.present(alerting, animated: true, completion: nil)
                        let when = DispatchTime.now() + 1
                        DispatchQueue.main.asyncAfter(deadline: when){
                          alerting.dismiss(animated: true, completion: nil)
                        }
                    })
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constantitems[7]) as! CustomUserTableViewCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
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
}
protocol userDetailViewControllerProtocol: AnyObject {
    func dataLoaded()
    func hideLoader()
}
