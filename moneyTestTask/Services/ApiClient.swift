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
    func getRates(for date: Date?, completion: @escaping (Result<RequestResult, ApiError>) -> Void)
}

final class ApiClient: ApiClientProtocol {
    func getRates(for date: Date?, completion: @escaping (Result<RequestResult, ApiError>) -> Void) {
        let stringUrl: String
        if let date = date {
            let stringDate = date.getStringDate()
            stringUrl = "https://www.cbr-xml-daily.ru/archive/\(stringDate)/daily_json.js"
        } else {
            stringUrl = Constants.URL.dailyRates
        }
        
        guard let requestUrl = URL(string: stringUrl) else { return }
        
        DispatchQueue.global().async {
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
}
