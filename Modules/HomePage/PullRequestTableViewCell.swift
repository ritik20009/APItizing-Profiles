//
//  CustomTableViewCell.swift
//  iOSLearningApp
//
//  Created by Ritik Raj on 23/09/22.
//

import Foundation
import UIKit
import SnapKit

final class PullRequestTableViewCell: UITableViewCell {
    
    private let favouriteButton = UIButton()
    private let titleLable = UILabel()
    private let profileImageView = UIImageView()
    private let headingLabel = UILabel()
    private let bodyView = UILabel()
    private let containerView = UIView()
    private let ViewModel = PullRequestViewModel()
    private let userDetailViewreference = UserDetailViewController()

    private var username: String = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    

    private func configure() {
        configureContentView()
        configureContainerView()
        configureProfileImageView()
        configureTitleLable()
        configureHeadingLabel()
        configureBodyView()
        configureFavouriteButton()
    }
    
    private func configureContentView() {
        contentView.backgroundColor = .white
        contentView.addSubview(containerView)
    }
    
    private func configureContainerView() {
        containerView.addSubview(titleLable)
        containerView.addSubview(profileImageView)
        containerView.addSubview(headingLabel)
        containerView.addSubview(bodyView)
        containerView.addSubview(favouriteButton)
        
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = CGFloat(NumberConstants.fifteen)
        containerView.snp.makeConstraints{make in
            make.top.left.equalToSuperview().offset(NumberConstants.ten)
            make.right.bottom.equalToSuperview().offset(NumberConstants.negten)
        }
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.black.cgColor
    }
    
    private func configureProfileImageView() {
        profileImageView.image = UIImage(named: ConstantItems.profileImage)
        profileImageView.clipsToBounds=true
        profileImageView.layer.cornerRadius=CGFloat(NumberConstants.fifty)
        profileImageView.snp.makeConstraints{make in
            make.left.equalToSuperview().offset(NumberConstants.ten)
            make.width.height.equalTo(NumberConstants.hundred)
            make.centerY.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(NumberConstants.negten).priority(.high)
        }
    }
    
    private func configureTitleLable() {
        titleLable.numberOfLines = 0
        titleLable.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLable.snp.makeConstraints{make in
            make.right.equalTo(favouriteButton).offset(20)
            make.top.equalToSuperview().offset(NumberConstants.ten)
            make.left.equalTo(profileImageView.snp.right).offset(NumberConstants.twenty)
        }
    }
    
    private func configureHeadingLabel() {
        headingLabel.numberOfLines = 0
        headingLabel.font = headingLabel.font.withSize(10)
        headingLabel.snp.makeConstraints{ make in
            make.top.equalTo(titleLable.snp.bottom).offset(10)
            make.left.equalTo(profileImageView.snp.right).offset(20)
            make.right.equalToSuperview().offset(-5)
        }
    }
    
    private func configureBodyView() {
        bodyView.numberOfLines = 0
        bodyView.font = bodyView.font.withSize(15)
        bodyView.snp.makeConstraints{ make in
            make.top.equalTo(headingLabel.snp.bottom).offset(10)
            make.left.equalTo(profileImageView.snp.right).offset(20)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    private func configureFavouriteButton() {
        favouriteButton.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-5)
        }
    }
    
    @objc func markFavourite() {
        UserDefaults.standard.set("", forKey: Utils.shared.getKeyForFavourite(userName: username))
        NotificationCenter.default.post(name: NSNotification.Name(NotificationCenterKeywords.observer), object: nil)
    }
    
    @objc func unMarkFavourite() {
        NotificationCenter.default.post(name: NSNotification.Name(NotificationCenterKeywords.observer), object: nil)
        UserDefaults.standard.removeObject(forKey: Utils.shared.getKeyForFavourite(userName: username))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data: Item?) -> String {
        guard let avatarurl = data?.user?.avatar_url else{ return "" }
        let setImage = {(data: Data) -> Void in
            guard let image = UIImage(data: data) else{ return }
            self.profileImageView.image = image
        }
        
        NetworkManager.shared.fetchImage(url: avatarurl, completion: setImage)
        username = data?.user?.login ?? ""
        if UserDefaults.standard.object(forKey: Utils.shared.getKeyForFavourite(userName: username)) == nil {
            favouriteButton.setImage(UIImage(systemName: ButtonSymbols.star), for: UIControl.State.normal)
            favouriteButton.addTarget(self, action: #selector(markFavourite), for: .touchUpInside)
        } else {
            favouriteButton.setImage(UIImage(systemName: ButtonSymbols.fillStar), for: UIControl.State.normal)
            favouriteButton.addTarget(self, action: #selector(unMarkFavourite), for: .touchUpInside)
        }
        titleLable.text = data?.user?.login
        headingLabel.text = data?.title
        bodyView.text = data?.body
        return titleLable.text ?? ""
    }
}

