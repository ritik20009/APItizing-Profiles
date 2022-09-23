//
//  ViewController.swift
//  iOSLearningApp
//
//  Created by Ritik Rj on 14/09/22.
//

import UIKit
import SnapKit




class ViewController: UIViewController, UITableViewDelegate {
    
    let titleLabel = UILabel()
    let tableView = UITableView()
    
    var spinner = UIActivityIndicatorView()
    var loadingLabel = UILabel()
    var loadingView = UIView()
    
    var pageNumber = 1
    
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
        
        let success: (_ res:SampleResponse) -> ()  = {(res)-> Void in
            
            self.response = res
            self.tableView.reloadData()
            self.hideLoader()
        }
        
        let showError: () -> ()  = {()-> Void in
            print("Inside error handler")
        }
        
        let file = FileManager()
        showLoader()
        let url = "https://api.github.com/repos/apple/swift/pulls?page=\(pageNumber)&per_page=10"
        file.fetchData(apiUrl: url,initialResponse: nil, success: success, failure: showError)
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
    
    
    
    func configure(){
        self.view.backgroundColor = .white
        titleLabel.text = "Table"
        view.addSubview(titleLabel)
        //        tableView.rowHeight = 100
        titleLabel.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(50)
            make.left.equalToSuperview().offset(175)
        }
        
        tableView.backgroundColor = .white
        tableView.register(CustomeTableViewCell.self, forCellReuseIdentifier: "CustomeTableViewCell")
        tableView.register(loadingData.self, forCellReuseIdentifier: "loadingData")
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingData") as! loadingData
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
            cell.showLoader()
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomeTableViewCell") as! CustomeTableViewCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
            self.user_login = cell.setData(data: self.response?.items?[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableSize = self.response?.items?.count else {
            return
        }
        
        //print("QQQQ \(indexPath.row)")
        if(indexPath.row == tableSize - 2){
            
            
            pageNumber+=1
            let success: (_ res:SampleResponse) -> ()  = {(res)-> Void in
                
                self.response = res
                self.tableView.reloadData()
            }
            
            let showError: () -> ()  = {()-> Void in
                print("Inside error handler")
            }
            
            let file = FileManager()
            let url = "https://api.github.com/repos/apple/swift/pulls?page=\(pageNumber)&per_page=10"
            file.fetchData(apiUrl: url,initialResponse: response, success: success, failure: showError)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userDetailsViewController = userDetailViewController()
        user_login = response?.items?[indexPath.row].user?.login
        userDetailsViewController.u_login = user_login
        self.navigationController?.pushViewController(userDetailsViewController, animated: true)
    }
    
}


class CustomeTableViewCell: UITableViewCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    let titleLable = UILabel()
    let profileImageView = UIImageView()
    let title = UILabel()
    let bodyView = UILabel()
    
    let containerView = UIView()
    
    
    func configure() {
        self.titleLable.numberOfLines = 0
        self.title.numberOfLines = 0
        self.bodyView.numberOfLines = 0
        self.contentView.addSubview(containerView)
        
        self.contentView.backgroundColor = .white
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 15
        containerView.snp.makeConstraints{make in
            make.top.left.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().offset(-10)
        }
        
        self.containerView.addSubview(titleLable)
        self.containerView.addSubview(profileImageView)
        self.containerView.addSubview(title)
        self.containerView.addSubview(bodyView)
        //containerView.selectionStyle = UITableViewCell.SelectionStyle.none
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.black.cgColor
        
        profileImageView.image = UIImage(named: "image1")
        profileImageView.clipsToBounds=true
        profileImageView.layer.cornerRadius=50
        
        profileImageView.snp.makeConstraints{make in
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(100)
            make.centerY.equalToSuperview()
            
        }
        
        titleLable.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLable.snp.makeConstraints{make in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(profileImageView.snp.right).offset(20)
        }
        
        title.snp.makeConstraints{ make in
            make.top.equalTo(titleLable.snp.bottom).offset(10)
            make.left.equalTo(profileImageView.snp.right).offset(20)
            make.right.equalToSuperview().offset(-5)
            
        }
        
        title.font = title.font.withSize(10)
        
        bodyView.snp.makeConstraints{ make in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.left.equalTo(profileImageView.snp.right).offset(20)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        bodyView.font = bodyView.font.withSize(15)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data: Item?) -> String{
        
        URLSession.shared.dataTask(with: NSURL(string: (data?.user?.avatar_url) ?? "https://www.pngfind.com/pngs/m/610-6104451_image-placeholder-png-user-profile-placeholder-image-png.png")! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "error")
                return
            }
            
            let image = UIImage(data: data!)
            DispatchQueue.main.async(execute: { () -> Void in
                self.profileImageView.image = image
            })
        }).resume()
        
        titleLable.text = data?.user?.login
        title.text = data?.title
        bodyView.text = data?.body
        return titleLable.text ?? ""
    }
}

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

class CustomeUserTableViewCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var key = UILabel()
    var value = UILabel()
    
    let ProfileImgView = UIImageView()
    
    //var ProfileImgView = UIImageView()
    
    
    let containerView = UIView()
    
    let userdatacons = UserDetailField.constants
    
    func configure() {
        
        self.contentView.addSubview(containerView)
        
        self.contentView.backgroundColor = .white
        containerView.backgroundColor = .white
        containerView.snp.makeConstraints{make in
            make.top.left.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().offset(-10)
        }
        
        self.containerView.addSubview(key)
        self.containerView.addSubview(value)
        
        key.snp.makeConstraints{ make in
            make.top.left.equalToSuperview().offset(5)
            make.bottom.right.equalToSuperview()
        }
        
        value.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(key).offset(250)
            make.bottom.right.equalToSuperview()
        }
    }
    
    func setData(data: UserDetail?, index: Int){
        
        
//        print(details)
        
        if(index==0){
            
            
            
            self.containerView.addSubview(ProfileImgView)
            ProfileImgView.image = UIImage(named: "image1")
            ProfileImgView.clipsToBounds=true
            ProfileImgView.layer.cornerRadius=100
            
            ProfileImgView.snp.makeConstraints{ make in
                make.centerX.centerY.equalToSuperview()
                make.height.width.equalTo(200)
                
            }
            
            containerView.snp.makeConstraints { make in
                
                make.height.equalTo(230)
            }
            
            
            let url = data?.avatar_url
            
            URLSession.shared.dataTask(with: NSURL(string: (url) ?? "https://www.pngfind.com/pngs/m/610-6104451_image-placeholder-png-user-profile-placeholder-image-png.png")! as URL, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print(error ?? "error")
                    return
                }
                
                let image = UIImage(data: data!)
                DispatchQueue.main.async(execute: { () -> Void in
                    self.ProfileImgView.image = image
                })
            }).resume()
            
            
            
            
        }
        if(index==1){
            self.value.numberOfLines=0
            key.text = self.userdatacons[index-1]
            value.text = data?.name
        }
        if(index==2){
            key.text = self.userdatacons[index-1]
            value.text = data?.email
        }
        if(index==3){
            self.value.numberOfLines=0
            key.text = self.userdatacons[index-1]
            value.text = data?.company
        }
        if(index==4){
            
            self.value.numberOfLines=0
            key.text = self.userdatacons[index-1]
            value.text = data?.location
        }
        
        if(index==5){
            key.text = self.userdatacons[index-1]
            value.text = data?.login
        }
        if(index==6){
            key.text = self.userdatacons[index-1]
            let repo_cnt : Int
            
            repo_cnt = (data?.public_repos) ?? 0
            
            value.text = "\(repo_cnt)"
        }
        if(index==7){
            key.text = self.userdatacons[index-1]
            let followers_cnt : Int
            
            followers_cnt = (data?.followers) ?? 0
            
            value.text = "\(followers_cnt)"
        }
        if(index==8){
            key.text = self.userdatacons[index-1]
            let following_cnt : Int
            
            following_cnt = (data?.following) ?? 0
            
            value.text = "\(following_cnt)"
        }
        
    }
}


class loadingData: UITableViewCell {
    let spinner = UIActivityIndicatorView()
    let loadingView = UIView()
    let loadingLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(){
        self.contentView.addSubview(loadingView)
        loadingView.snp.makeConstraints{ make in
            make.top.bottom.left.right.equalToSuperview().offset(5)
        }
        
        loadingView.addSubview(loadingLabel)
    }
    
    func showLoader() {
        loadingView.backgroundColor = .white
        
        spinner.color = .lightGray
        spinner.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        loadingView.backgroundColor = .white
        loadingView.snp.makeConstraints{make in
            make.centerX.centerY.equalToSuperview()
        }
        loadingView.addSubview(spinner)
        spinner.snp.makeConstraints{make in
            make.top.bottom.equalToSuperview().offset(10)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        spinner.startAnimating()
    }
}
