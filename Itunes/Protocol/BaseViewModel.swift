//
//  BaseViewModel.swift
//  Itunes
//
//  Created by 홍정민 on 8/9/24.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
