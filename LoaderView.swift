//
//  LoaderView.swift
//  iOSLearningApp
//
//  Created by Ritik Raj on 23/09/22.
//

import Foundation
import SnapKit
import UIKit

class loadingData: UITableViewCell {
    private let spinner = UIActivityIndicatorView()
    private let loadingView = UIView()
    private let loadingLabel = UILabel()
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
