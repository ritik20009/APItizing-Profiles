//
//  LoaderView.swift
//  iOSLearningApp
//
//  Created by Ritik Raj on 23/09/22.
//

import Foundation
import SnapKit
import UIKit

final class LoaderViewCell: UITableViewCell {
    
    private let spinner = UIActivityIndicatorView()
    private let loadingView = UIView()
    private let loadingLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError(ErrorDescription.fatalError)
    }
    
    func configure(){
        contentView.addSubview(loadingView)
        
        loadingView.addSubview(loadingLabel)
        loadingView.snp.makeConstraints{ make in
            make.top.bottom.left.right.equalToSuperview().offset(5)
        }
    }
    
    func showLoader() {
        loadingView.backgroundColor = .white
        loadingView.addSubview(spinner)
        loadingView.snp.makeConstraints{make in
            make.centerX.centerY.equalToSuperview()
        }
        
        spinner.color = .lightGray
        spinner.transform = CGAffineTransform(scaleX: 2, y: 2)
        spinner.snp.makeConstraints{make in
            make.top.bottom.equalToSuperview().offset(10)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        spinner.startAnimating()
    }
}
