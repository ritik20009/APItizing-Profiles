//
//  CustomUserTableView.swift
//  iOSLearningApp
//
//  Created by Ritik Raj on 23/09/22.
//

import Foundation
import UIKit
import SnapKit

final class UserDetailsTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError(ErrorDescription.fatalError)
    }
    
    private let keyLabel = UILabel()
    private let valueLabel = UILabel()
    private let ProfileImgView = UIImageView()
    private let containerView = UIView()

    private func configure() {
        configureContentView()
        configureContainerView()
        configureKeyLabel()
        configureValueLabel()
    }
    
    private func configureContentView() {
        contentView.addSubview(containerView)
        contentView.backgroundColor = .white
    }
    
    private func configureContainerView() {
        containerView.backgroundColor = .white
        containerView.addSubview(keyLabel)
        containerView.addSubview(valueLabel)
        containerView.snp.makeConstraints{make in
            make.top.left.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private func configureKeyLabel() {
        keyLabel.snp.makeConstraints{make in
            make.top.left.equalToSuperview().offset(5)
            make.bottom.right.equalToSuperview()
        }
    }
    
    private func configureValueLabel() {
        valueLabel.numberOfLines = NumberConstants.zero
        valueLabel.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(keyLabel).offset(250)
            make.bottom.right.equalToSuperview()
        }
    }
    
    private func configureProfileImageView() {
        ProfileImgView.image = UIImage(named: ConstantItems.profileImage)
        ProfileImgView.clipsToBounds = true
        ProfileImgView.layer.cornerRadius = 100
        ProfileImgView.snp.makeConstraints{make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(200)
        }
    }
    
    private func configureProfileImageContainerView() {
        containerView.addSubview(ProfileImgView)
        containerView.snp.makeConstraints {make in
            make.height.equalTo(230)
        }
    }
    
    private func setProfileImage(avatarUrl: String){
        
        let setImage = {(data: Data) -> Void in
            guard let image = UIImage(data: data) else { return }
            self.ProfileImgView.image = image
        }
        NetworkManager.shared.fetchImage(url: avatarUrl, completion: setImage)
    }
    
    func setData(data: UserDetail?, index: Int){
        if(index == 0){
            configureProfileImageContainerView()
            configureProfileImageView()
            guard let avatarurl = data?.avatar_url else {
                return
            }
            setProfileImage(avatarUrl: avatarurl)
        }
        
        if(index == 1){
            keyLabel.text = UserDetailsFields.name
            valueLabel.text = data?.name ?? ConstantItems.none
        }
        
        if(index == 2){
            keyLabel.text = UserDetailsFields.company
            valueLabel.text = data?.company ?? ConstantItems.none
        }
        
        if(index == 3){
            keyLabel.text = UserDetailsFields.location
            valueLabel.text = data?.location ?? ConstantItems.none
        }
        
        if(index == 4){
            keyLabel.text = UserDetailsFields.login
            valueLabel.text = data?.login ?? ConstantItems.none
        }
        
        if(index == 5){
            keyLabel.text = UserDetailsFields.publicRepos
            let repo_cnt : Int
            repo_cnt = (data?.public_repos) ?? 0
            valueLabel.text = "\(repo_cnt)"
        }
        
        if(index == 6){
            keyLabel.text = UserDetailsFields.followers
            let followers_cnt : Int
            followers_cnt = (data?.followers) ?? 0
            valueLabel.text = "\(followers_cnt)"
        }
        
        if(index == 7){
            keyLabel.text = UserDetailsFields.following
            let following_cnt : Int
            following_cnt = (data?.following) ?? 0
            valueLabel.text = "\(following_cnt)"
        }
    }
}
