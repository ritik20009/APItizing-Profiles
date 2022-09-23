//
//  CustomUserTableView.swift
//  iOSLearningApp
//
//  Created by Ritik Raj on 23/09/22.
//

import Foundation
import UIKit
import SnapKit

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
