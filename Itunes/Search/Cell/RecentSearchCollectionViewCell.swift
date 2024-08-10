//
//  RecentSearchCollectionViewCell.swift
//  Itunes
//
//  Created by 홍정민 on 8/10/24.
//

import UIKit
import SnapKit

final class RecentSearchCollectionViewCell: UICollectionViewCell {
    private let recentKeywordLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(){
        contentView.addSubview(recentKeywordLabel)
    
        recentKeywordLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        recentKeywordLabel.font = .systemFont(ofSize: 13)
        
        backgroundColor = .systemGray5
        layer.cornerRadius = 15
        clipsToBounds = true
    }
    
    func configureData(data: String){
        recentKeywordLabel.text = data
    }
}
