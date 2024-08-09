//
//  SearchDetailViewController.swift
//  Itunes
//
//  Created by 홍정민 on 8/9/24.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import SnapKit

final class SearchDetailViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let downloadButton = UIButton()
    private let releaseTitleLabel = UILabel()
    private let releaseSubtitleLabel = UILabel()
    private let releaseLabel = UILabel()
    private let previewLabel = UILabel()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let descriptionLabel = UILabel()
    
    let viewModel = SearchDetailViewModel()
    
    private func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 250, height: 450)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return layout
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        configureHierarchy()
        configureLayout()
        configureUI()
        bind()
    }
    
    private func configureHierarchy(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(downloadButton)
        contentView.addSubview(releaseTitleLabel)
        contentView.addSubview(releaseSubtitleLabel)
        contentView.addSubview(releaseLabel)
        contentView.addSubview(previewLabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(descriptionLabel)
    }
    
    private func configureLayout(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView)
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.trailing.equalTo(contentView.safeAreaInsets).offset(-20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(titleLabel)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(subtitleLabel)
        }
        
        releaseTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
        
        releaseSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(releaseTitleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
        
        releaseLabel.snp.makeConstraints { make in
            make.top.equalTo(releaseSubtitleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
        
        previewLabel.snp.makeConstraints { make in
            make.top.equalTo(releaseLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(previewLabel.snp.bottom).offset(4)
            make.height.equalTo(450)
            make.horizontalEdges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(contentView).offset(-10)
        }
        
    }
    
    private func configureUI(){
        iconImageView.layer.cornerRadius = 10
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFill
        titleLabel.numberOfLines = 2
        titleLabel.font = .boldSystemFont(ofSize: 17)
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .lightGray
        releaseTitleLabel.font = .boldSystemFont(ofSize: 17)
        releaseSubtitleLabel.font = .systemFont(ofSize: 14)
        releaseSubtitleLabel.textColor = .lightGray
        releaseLabel.font = .systemFont(ofSize: 14)
        previewLabel.font = .boldSystemFont(ofSize: 17)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 14)
        
        releaseTitleLabel.text = "새로운 소식"
        releaseLabel.numberOfLines = 0
        previewLabel.text = "미리 보기"
        collectionView.register(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: PreviewCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        
        downloadButton.configuration = .download
        downloadButton.configuration?.title = "열기"
    }
    
    private func bind(){
        let input = SearchDetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.detailItunesData
            .bind(with: self) { owner, value in
                owner.configureData(value)
            }
            .disposed(by: disposeBag)
        
        output.detailItunesData
            .map { $0.screenshotUrls }
            .bind(to: collectionView.rx.items(cellIdentifier: PreviewCollectionViewCell.identifier, cellType: PreviewCollectionViewCell.self)){
            (row, element, cell) in
                cell.configureData(data: element)
        }.disposed(by: disposeBag)
    }
    
    private func configureData(_ data: Itunes){
        if let url = URL(string: data.artworkUrl512) {
            iconImageView.kf.setImage(with: url)
        }
        
        titleLabel.text = data.trackName
        subtitleLabel.text = data.artistName
        releaseLabel.text = data.releaseNotes
        releaseSubtitleLabel.text = "버전" + data.version
        descriptionLabel.text = data.description
    }
}
