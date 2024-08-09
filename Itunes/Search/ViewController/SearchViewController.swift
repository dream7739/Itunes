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
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
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
        
        collectionView.rx.itemSelected
            .bind(with: self) { owner, index in
                print(index)
            }

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

