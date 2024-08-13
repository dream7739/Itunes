//
//  SearchViewController.swift
//  Itunes
//
//  Created by 홍정민 on 8/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class SearchViewController: UIViewController {
    
    private let searchController = UISearchController()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
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
        bind()
    }
    
    private func bind() {
        let input = SearchViewModel.Input(
            searchText: searchController.searchBar.rx.text.orEmpty,
            searchButtonTap: searchController.searchBar.rx.searchButtonClicked
        )
        
        let output = viewModel.transform(input: input)
        
        let dataSource = configureDataSource()
        
        output.sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .bind(with: self) { owner, value in
                guard let section = Section(rawValue: value.section), section == .main else { return }
                let detailVC = SearchDetailViewController()
                let data = owner.viewModel.response.results[value.item]
                detailVC.viewModel.detailData = data
                owner.navigationController?.pushViewController(detailVC, animated: true)
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
        
        collectionView.register(RecentSearchCollectionViewCell.self, forCellWithReuseIdentifier: RecentSearchCollectionViewCell.identifier)
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
    }
    
    private func configureDataSource() -> RxCollectionViewSectionedReloadDataSource<MultipleSectionModel> {
        return RxCollectionViewSectionedReloadDataSource { dataSource, collectionView, indexPath, item in
            switch dataSource[indexPath]{
            case .keywords(let keyword):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCollectionViewCell.identifier, for: indexPath) as? RecentSearchCollectionViewCell else { return UICollectionViewCell() }
                cell.configureData(data: keyword)
                return cell
            case .results(let result):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
                cell.configureData(data: result)
                return cell
            }
        }
        
    }
    
    
}

extension SearchViewController {
    enum Section: Int, CaseIterable {
        case keyword = 0
        case main = 1
    }
}

enum MultipleSectionModel: SectionModelType {
    typealias Item = SectionItem
    
    case searchKeywordSection(items: [SectionItem])
    case searchResultSection(items: [SectionItem])
    
    var items: [SectionItem] {
        switch self {
        case .searchKeywordSection(let items):
            return items
        case .searchResultSection(let items):
            return items
        }
    }
    
    init(original: MultipleSectionModel, items: [SectionItem]) {
        switch original {
        case .searchKeywordSection(let items):
            self = .searchKeywordSection(items: items)
        case .searchResultSection(let items):
            self = .searchResultSection(items: items)
        }
    }
}

enum SectionItem {
    case keywords(keyword: String)
    case results(result: Itunes)
    
}

