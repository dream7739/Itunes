//
//  ItunesCollectionViewCell.swift
//  Itunes
//
//  Created by 홍정민 on 8/9/24.
//

import UIKit
import SnapKit
import Kingfisher

final class ItunesCollectionViewCell: UICollectionViewCell {
    static let identifier = "ItunesCollectionViewCell"
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let downloadButton = UIButton()
    
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
        
        iconImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
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
        
        iconImageView.backgroundColor = .red
        iconImageView.layer.cornerRadius = 10
        iconImageView.clipsToBounds = true
        
        titleLabel.font = .boldSystemFont(ofSize: 14)
        
        downloadButton.layer.cornerRadius = 10
        downloadButton.clipsToBounds = true
        downloadButton.setTitle("받기", for: .normal)
        downloadButton.backgroundColor = .lightGray
        downloadButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    func configureData(data: Itunes){
        if let url = URL(string: data.artworkUrl100) {
            iconImageView.kf.setImage(with: url)
        }
        
        titleLabel.text = data.trackName
    }
}
