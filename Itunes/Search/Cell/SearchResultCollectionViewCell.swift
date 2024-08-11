//
//  SearchResultCollectionViewCell.swift
//  Itunes
//
//  Created by 홍정민 on 8/9/24.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchResultCollectionViewCell: UICollectionViewCell {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let downloadButton = UIButton()
    private let previewStackView = UIStackView()
    private let previewImage1 = UIImageView()
    private let previewImage2 = UIImageView()
    private let previewImage3 = UIImageView()
    
    private lazy var previewImages = [previewImage1, previewImage2, previewImage3]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(){
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(downloadButton)
        contentView.addSubview(previewStackView)
        previewStackView.addArrangedSubview(previewImage1)
        previewStackView.addArrangedSubview(previewImage2)
        previewStackView.addArrangedSubview(previewImage3)
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.size.equalTo(60)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.trailing.equalTo(downloadButton.snp.leading).offset(-8)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.width.equalTo(64)
            make.height.equalTo(30)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-10)
        }
        
        previewStackView.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(230)
        }
        
        iconImageView.backgroundColor = .red
        iconImageView.layer.cornerRadius = 10
        iconImageView.clipsToBounds = true
        
        titleLabel.font = .boldSystemFont(ofSize: 14)
        
        downloadButton.configuration = .download
        downloadButton.configuration?.title = "받기"
        
        previewStackView.axis = .horizontal
        previewStackView.spacing = 10
        previewStackView.distribution = .fillEqually
        
        previewImage1.backgroundColor = .lightGray
        previewImage1.layer.cornerRadius = 10
        previewImage1.clipsToBounds = true
        
        previewImage2.backgroundColor = .lightGray
        previewImage2.layer.cornerRadius = 10
        previewImage2.clipsToBounds = true
        
        previewImage3.backgroundColor = .lightGray
        previewImage3.layer.cornerRadius = 10
        previewImage3.clipsToBounds = true
    }
    
    func configureData(data: Itunes){
        if let url = URL(string: data.artworkUrl100) {
            iconImageView.kf.setImage(with: url)
        }
        
        titleLabel.text = data.trackName
        
        for (idx, screenshot) in data.screenshotUrls.enumerated() {
            if idx > 2 { return }
            
            if let url = URL(string: screenshot) {
                previewImages[idx].kf.setImage(with: url)
            }
        }
    }
}
