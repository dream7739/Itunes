//
//  SearchViewModel.swift
//  Itunes
//
//  Created by 홍정민 on 8/9/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: BaseViewModel {
    
    private let disposeBag = DisposeBag()
    var response = ItunesResponse(resultCount: 0, results: [])
    
    struct Input {
        let searchText: ControlProperty<String>
        let searchButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let sections: BehaviorRelay<[MultipleSectionModel]>
    }
    
    
    func transform(input: Input) -> Output {
        let searchList = BehaviorRelay(value: UserDefaultsManager.searchList)
        let resultList = PublishSubject<[Itunes]>()
        let sections = BehaviorRelay(value: createInitialSection())
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .map { value in
                UserDefaultsManager.searchList[value] = Date()
                return value
            }
            .map { $0.replacingOccurrences(of: " ", with: "+") }
            .flatMap {
                NetworkManager.shared.callRequest(term: $0)
            }
            .subscribe(with: self) { owner, response in
                owner.response = response
                resultList.onNext(owner.response.results)
            } onError: { owner, error in
                print("error, \(error)")
            } onCompleted: { owner in
                print("complete")
            } onDisposed: { owner in
                print("disposed")
            }
            .disposed(by: disposeBag)
        
        resultList
            .bind(with: self) { owner, value in
                let section = owner.updateSectionData(value)
                sections.accept(section)
            }
            .disposed(by: disposeBag)
        
        return Output(
            sections: sections
        )
    }
    
    private func createInitialSection() -> [MultipleSectionModel] {
        let initialItem = UserDefaultsManager.searchList
            .map { $0.key }
            .map { SectionItem.keywords(keyword: $0) }
        
        let initialSection = [
            MultipleSectionModel.searchKeywordSection(items: initialItem)
        ]
        
        return initialSection
        
    }
    
    private func updateSectionData(_ data: [Itunes]) -> [MultipleSectionModel] {
        let keywordItem = UserDefaultsManager.searchList
            .map { $0.key }
            .map { SectionItem.keywords(keyword: $0) }
        
        let resultItem = data.map { SectionItem.results(result: $0) }
        
        let section = [
            MultipleSectionModel.searchKeywordSection(items: keywordItem),
            MultipleSectionModel.searchResultSection(items: resultItem)
        ]
        
        return section
    }
}
