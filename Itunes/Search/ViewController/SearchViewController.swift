//
//  SearchViewController.swift
//  Itunes
//
//  Created by 홍정민 on 8/8/24.
//

import UIKit
import SnapKit
import RxSwift

final class SearchViewController: UIViewController {
    
    private let searchController = UISearchController()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { section, env in
            switch Section.allCases[section] {
            case .keyword:
                let keywordItemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension:  .fractionalHeight(1))
                let keywordItem = NSCollectionLayoutItem(layoutSize: keywordItemSize)
                let containerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
                let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerSize, subitems: [keywordItem])
                containerGroup.interItemSpacing = .fixed(4)
                let section = NSCollectionLayoutSection(group: containerGroup)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
                section.orthogonalScrollingBehavior = .continuous
                return section
            case .main:
                let infoItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let infoItem = NSCollectionLayoutItem(layoutSize: infoItemSize)
                
                let containerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(350))
                let containerGroup = NSCollectionLayoutGroup.vertical(layoutSize: containerSize, subitems: [infoItem])
                
                let section = NSCollectionLayoutSection(group: containerGroup)
                return section
            }
        }
        
        return layout
    }
    
    let viewModel = SearchViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureDataSource()
        applyInitialSnapshot()
        bind()
    }
    
    private func bind(){
        let input = SearchViewModel.Input(
            searchText: searchController.searchBar.rx.text.orEmpty,
            searchButtonTap: searchController.searchBar.rx.searchButtonClicked
        )
        
        let output = viewModel.transform(input: input)
        
        output.resultList
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                owner.updateSnapshot(data: value)
            } onError: { owner, error in
                print("error \(error)")
            } onCompleted: { owner in
                print("complete")
            } onDisposed: { owner in
                print("disposed")
            }
            .disposed(by: disposeBag)
        
        
    }
    
    private func configureView(){
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "검색"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.delegate = self
    }
    
    private func configureDataSource(){
        let keywordRegisteration = UICollectionView.CellRegistration<RecentSearchCollectionViewCell, String> { cell, indexPath, itemIdentifier in
            cell.configureData(data: itemIdentifier)
        }
        
        let mainRegisteration = UICollectionView.CellRegistration<ItunesCollectionViewCell, Itunes> { cell, indexPath, itemIdentifier in
            cell.configureData(data: itemIdentifier)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch Section.allCases[indexPath.section] {
            case .keyword:
                guard let item = itemIdentifier as? String else { return UICollectionViewCell() }
                let cell = collectionView.dequeueConfiguredReusableCell(using: keywordRegisteration, for: indexPath, item: item)
                return cell
            case .main:
                guard let item = itemIdentifier as? Itunes else { return UICollectionViewCell() }
                let cell = collectionView.dequeueConfiguredReusableCell(using: mainRegisteration, for: indexPath, item: item)
                return cell
            }
        })
        
    }
    
    private func applyInitialSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.keyword, .main])
        snapshot.appendItems(["안녕", "하세", "요"], toSection: .keyword)
        dataSource.apply(snapshot)
        
    }
    
    private func updateSnapshot(data: [Itunes]){
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .main))
        snapshot.appendItems(data, toSection: .main)
        dataSource.apply(snapshot)
    }
}

extension SearchViewController {
    enum Section: CaseIterable {
        case keyword
        case main
    }
    
    typealias Item = AnyHashable
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = dataSource.sectionIdentifier(for: indexPath.section)
        
        if section == .main {
            if let data = dataSource.itemIdentifier(for: indexPath) as? Itunes {
                let detailVC = SearchDetailViewController()
                detailVC.viewModel.detailData = data
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
}
