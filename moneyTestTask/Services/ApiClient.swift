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
    func getDailyRates(completion: @escaping (Result<RequestResult, ApiError>) -> Void)
    func getDailyRates(for date: Date, completion: @escaping (Result<RequestResult, ApiError>) -> Void)
}

final class ApiClient: ApiClientProtocol {
    func getDailyRates(completion: @escaping (Result<RequestResult, ApiError>) -> Void) {
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
    
    func getDailyRates(for date: Date, completion: @escaping (Result<RequestResult, ApiError>) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"

        let stringDate = dateFormatter.string(from: date)
        let urlString = "https://www.cbr-xml-daily.ru/archive/\(stringDate)/daily_json.js"
        
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url).responseData { response in
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
