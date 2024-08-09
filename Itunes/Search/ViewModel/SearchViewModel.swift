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
    
    struct Input {
        let searchText: ControlProperty<String>
        let searchButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let resultList: PublishSubject<[Itunes]>
    }
    
    
    func transform(input: Input) -> Output {
        let resultList = PublishSubject<[Itunes]>()
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .map { $0.replacingOccurrences(of: " ", with: "+") }
            .flatMap {
                NetworkManager.shared.callRequest(term: $0)
            }
            .subscribe(with: self) { owner, response in
                resultList.onNext(response.results)
            } onError: { owner, error in
                print("error, \(error)")
            } onCompleted: { owner in
                print("complete")
            } onDisposed: { owner in
                print("disposed")
            }
            .disposed(by: disposeBag)

        
        return Output(resultList: resultList)
    }
}
