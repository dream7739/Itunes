//
//  PreviewCollectionViewCell.swift
//  Itunes
//
//  Created by 홍정민 on 8/9/24.
//

import UIKit
import Kingfisher
import SnapKit

final class PreviewCollectionViewCell: UICollectionViewCell {
    static let identifier = "PreviewCollectionViewCell"
    
    private let previewImageView = UIImageView()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(){
        contentView.addSubview(previewImageView)
        
        previewImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        previewImageView.layer.cornerRadius = 10
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true
    }
    
    func configureData(data: String){
        guard let url = URL(string: data) else { return }
        previewImageView.kf.setImage(with: url)
    }
}
