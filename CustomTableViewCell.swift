//
//  CustomTableViewCell.swift
//  iOSLearningApp
//
//  Created by Ritik Raj on 23/09/22.
//

import Foundation
import UIKit
import SnapKit

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

