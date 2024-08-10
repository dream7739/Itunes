//
//  SearchDetailViewModel.swift
//  Itunes
//
//  Created by 홍정민 on 8/9/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchDetailViewModel: BaseViewModel {
    var detailData: Itunes?

    struct Input {
    }
    
    struct Output {
        let detailItunesData: BehaviorRelay<Itunes?>
    }
    
    func transform(input: Input) -> Output {
        let detailItunesData = BehaviorRelay(value: detailData)
        
        return Output(detailItunesData: detailItunesData)
        
    }
    
    
}
