//
//  SATScoreQuery.swift
//  NYCSchools
//
//  Created by Nicholas Kraft on 1/11/23.
//

import Foundation

class SATScoreQuery {
    static let endpoint: String = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json"
    
    static let dbnKey: String = "dbn"
    static let mathAverageKey: String = "sat_math_avg_score"
    static let writingAverageKey: String = "sat_writing_avg_score"
    static let criticalReadingAverageKey: String = "sat_critical_reading_avg_score"
    static let numberOfTestTakersKey: String = "num_of_sat_test_takers"
    static let schoolNameKey: String = "school_name"
    
    private(set) var data: [AnyHashable: Any]?
    private(set) var error: Error?
    
    private init(data: [AnyHashable : Any]? = nil, error: Error? = nil) {
        self.data = data
        self.error = error
    }
    
    static func satResultsQuery(forDBN dbnString: String, _ completion:@escaping(SATScoreQuery) -> Void) {
        var endpointURL = URL.init(string:SATScoreQuery.endpoint)
        endpointURL?.append(queryItems: [URLQueryItem.init(name: SATScoreQuery.dbnKey, value: dbnString)])
        guard let endpointURL = endpointURL else {
            DispatchQueue.main.async {
                completion(SATScoreQuery.init())
            }
            return
        }
        let request = URLRequest.init(url: endpointURL, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 30)
        URLSession.shared.dataTask(with: request, completionHandler: { [completion] (data: Data?, urlRespoinse: URLResponse?, error: Error?) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(SATScoreQuery.init(data: nil, error: error))
                }
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data) as! [[AnyHashable : Any]]? {
                DispatchQueue.main.async {
                    completion(SATScoreQuery.init(data: json.first))
                }
            } else {
                DispatchQueue.main.async {
                    completion(SATScoreQuery.init(data: nil, error: error))
                }
            }
        }).resume()
    }
    
    // MARK: - Data accessors -
    
    func schoolName() -> String? {
        return data?[Self.schoolNameKey] as? String
    }
    
    func mathAverage() -> String? {
        if let mathAverage = data?[Self.mathAverageKey] as? String {
            return mathAverage
        }
        return nil
    }
    
    func writingAverage() -> String? {
        if let writingAverage = data?[Self.writingAverageKey] as? String {
            return writingAverage
        }
        return nil
    }
    
    func criticalReadingAverage() -> String? {
        if let criticalReadingAverage = data?[Self.criticalReadingAverageKey] as? String {
            return criticalReadingAverage
        }
        return nil
    }
    
    func numberOfTestTakers() -> String? {
        if let numberOfTestTakers = data?[Self.numberOfTestTakersKey] as? String {
            return numberOfTestTakers
        }
        return nil
    }
}
