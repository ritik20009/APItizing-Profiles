//
//  CustomTableViewCell.swift
//  iOSLearningApp
//
//  Created by Ritik Raj on 23/09/22.
//

import Foundation
import UIKit
import SnapKit

class CustomTableViewCell: UITableViewCell{
    
    private let Constantitems = ConstantItems.items
    let ViewModel = HomePageViewModel()
    let favouriteButton = UIButton()
    var username: String = ""
    
    var userDetailViewreference = userDetailViewController()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    private let titleLable = UILabel()
    private let profileImageView = UIImageView()
    private let title = UILabel()
    private let bodyView = UILabel()
    private let containerView = UIView()
    func configure() {
        
        print(username)
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
        self.containerView.addSubview(favouriteButton)
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.black.cgColor
        profileImageView.image = UIImage(named: Constantitems[5])
        profileImageView.clipsToBounds=true
        profileImageView.layer.cornerRadius=50
        profileImageView.snp.makeConstraints{make in
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(100)
            make.centerY.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-10).priority(.high)
        }
        titleLable.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLable.snp.makeConstraints{make in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(profileImageView.snp.right).offset(20)
        }
        favouriteButton.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(titleLable).offset(215)
            make.right.equalToSuperview().offset(-5)
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
        guard let avatarurl = data?.user?.avatar_url else{
            return ""
        }
        let setImage = {(data: Data) -> Void in
            guard let image = UIImage(data: data) else{
                return
            }
            self.profileImageView.image = image
        }
        
        let network = NetworkManager()
        network.fetchImage(url: avatarurl, completion: setImage)
        username = data?.user?.login ?? ""
        if UserDefaults.standard.object(forKey: "favourite\(username)")==nil {
            favouriteButton.setImage(UIImage(systemName: "star"), for: UIControl.State.normal)
        }
        else{
            favouriteButton.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
        }
        titleLable.text = data?.user?.login
        title.text = data?.title
        bodyView.text = data?.body
        return titleLable.text ?? ""
    }
}

