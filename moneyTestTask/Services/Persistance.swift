//
//  Persistance.swift
//  moneyTestTask
//
//  Created by Давид Тоноян  on 18.01.2023.
//

import Foundation
import RealmSwift

enum RealmError: Error {
    case writeError
}

protocol PersistanceProtocol {
    func readFrom(date: String) -> RequestResult?
    func writeTo(object: RequestResult) throws
}

final class Persistance: PersistanceProtocol {
    static let shared: PersistanceProtocol = Persistance()
    
    private let realmConverter: ConverterProtocol = RealmConverter()
    private let realm = try? Realm()
    
    func readFrom(date: String) -> RequestResult? {
        guard let realm else { return nil }
        
        let objects = realm.objects(RealmCurrencyRate.self)
        
        var filteredObjects = [RealmCurrencyRate]()
        
        for object in objects where object.date.formatDate() == date {
            filteredObjects.append(object)
        }
        
        if filteredObjects.isEmpty {
            return nil
        } else {
            return realmConverter.convertFromRealm(object: filteredObjects)
        }        
    }
    
    func writeTo(object: RequestResult) throws {
        guard let realm else { return }
        
        let realmObject = realmConverter.convertToRealm(object: object)
        
        do {
            try realm.write { realm.add(realmObject) }
        } catch {
            throw RealmError.writeError
        }
    }
}

final class RealmCurrencyRate: Object {
    @objc dynamic var date = ""
    @objc dynamic var charCode = ""
    @objc dynamic var nominal = 0
    @objc dynamic var name = ""
    @objc dynamic var value = 0.0
}

private protocol ConverterProtocol {
    func convertToRealm(object: RequestResult) -> [RealmCurrencyRate]
    func convertFromRealm(object: [RealmCurrencyRate]) -> RequestResult
}

final class RealmConverter: ConverterProtocol {
    func convertToRealm(object: RequestResult) -> [RealmCurrencyRate] {
        var result = [RealmCurrencyRate]()
        let charCodeArray = object.currencyRates.keys
        
        for charCode in charCodeArray {
            guard let currency = object.currencyRates[charCode] else { break }
            
            let realmObject = RealmCurrencyRate()
            realmObject.date = object.date
            realmObject.charCode = charCode
            realmObject.nominal = currency.nominal
            realmObject.name = currency.name
            realmObject.value = currency.value
            
            result.append(realmObject)
        }
        
        return result
    }
    
    func convertFromRealm(object: [RealmCurrencyRate]) -> RequestResult {
        var currencyRates = [String: Currency]()
        
        for currencyRate in object {
            let currency = Currency(charCode: currencyRate.charCode,
                                    nominal: currencyRate.nominal,
                                    name: currencyRate.name,
                                    value: currencyRate.value)
            currencyRates[currencyRate.charCode] = currency
        }
        
        let result = RequestResult(date: object.first?.date ?? "", currencyRates: currencyRates)
        
        return result
    }
}
