//
//  NetworkManager.swift
//  Itunes
//
//  Created by 홍정민 on 8/9/24.
//

import Foundation
import RxSwift

final class NetworkManager {
    private init(){ }
    static let shared = NetworkManager()
    
    func callRequest(term: String) -> Single<Result<ItunesResponse, NetworkError>> {
        let result = Single<Result<ItunesResponse, NetworkError>>.create { observer in
            let term = URLQueryItem(name: "term", value: term)
            let country = URLQueryItem(name: "country", value: "KR")
            let media = URLQueryItem(name: "media", value: "software")
            
            var component = URLComponents(string: APIURL.itunes)
            component?.queryItems = [term, country, media]
            
            guard let url = component?.url else {
                observer(.success(.failure(NetworkError.invalidURL)))
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let _ = error {
                    observer(.success(.failure(NetworkError.unknownError)))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else{
                    observer(.failure(NetworkError.invalidStatus))
                    return
                }
                
                if let data = data, let decodedData = try? JSONDecoder().decode(ItunesResponse.self, from: data) {
                    observer(.success(.success(decodedData)))
                }else {
                    observer(.success(.failure(NetworkError.noData)))
                }
                
            }.resume()

            return Disposables.create()
        }
        
        return result
    }
}
