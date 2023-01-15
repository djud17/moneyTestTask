//
//  ApiClient.swift
//  moneyTestTask
//
//  Created by Давид Тоноян  on 15.01.2023.
//

import Alamofire

enum ApiError: Error {
    case noData
    case wrongData
    case serverError
}

protocol ApiClientProtocol {
    func getDailyRates(completion: @escaping (Result<RequestResult, ApiError>) -> (Void))
}

final class ApiClient: ApiClientProtocol {
    func getDailyRates(completion: @escaping (Result<RequestResult, ApiError>) -> (Void)) {
        guard let requestUrl = URL(string: Constants.URL.dailyRates) else { return }
        
        AF.request(requestUrl).responseData { response in
            if response.response?.statusCode == 200 {
                if let data = response.data {
                    do {
                        let results = try JSONDecoder().decode(RequestResult.self, from: data)
                        completion(.success(results))
                    } catch {
                        completion(.failure(.wrongData))
                    }
                } else {
                    completion(.failure(.noData))
                }
            } else {
                completion(.failure(.serverError))
            }
        }
    }
}
