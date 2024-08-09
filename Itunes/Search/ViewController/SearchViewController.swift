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
    
    private var dataSource: UICollectionViewDiffableDataSource<String, Itunes>!
    
    private func layout() -> UICollectionViewLayout {
        let infoItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let infoItem = NSCollectionLayoutItem(layoutSize: infoItemSize)
        
        let containerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(350))
        let containerGroup = NSCollectionLayoutGroup.vertical(layoutSize: containerSize, subitems: [infoItem])
        
        let section = NSCollectionLayoutSection(group: containerGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    let viewModel = SearchViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
        configureDataSource()
    }
    
    private func bind(){
        let input = SearchViewModel.Input(
            searchText: searchController.searchBar.rx.text.orEmpty,
            searchButtonTap: searchController.searchBar.rx.searchButtonClicked
        )
        
        let output = viewModel.transform(input: input)
        
        output.resultList
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
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.delegate = self
    }
    
    private func configureDataSource(){
        var registeration: UICollectionView.CellRegistration<ItunesCollectionViewCell, Itunes>!
        
        registeration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registeration, for: indexPath, item: itemIdentifier)
            cell.configureData(data: itemIdentifier)
            return cell
        })
        
    }
    
    private func updateSnapshot(data: [Itunes]){
        var snapshot = NSDiffableDataSourceSnapshot<String, Itunes>()
        snapshot.appendSections(["main"])
        snapshot.appendItems(data)
        dataSource.apply(snapshot)
    }
    
    
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = SearchDetailViewController()
        detailVC.viewModel.detailData = dataSource.itemIdentifier(for: indexPath)
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
}
