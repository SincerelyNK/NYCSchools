//
//  SchoolDirectoryQuery.swift
//  NYCSchools
//
//  Created by Nicholas Kraft on 1/11/23.
//

import Foundation

class SchoolDirectoryQuery {
    static let endpoint: String = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
        
    static let schoolNameKey: String = "school_name"
    static let dbnKey: String = "dbn"
    
    private(set) var data: [[AnyHashable: Any]]?
    private(set) var error: Error?
    
    private init(data: [[AnyHashable : Any]]? = nil, error: Error? = nil) {
        self.data = data
        self.error = error
    }
    
    static func newSchoolQuery(_ completion:@escaping(SchoolDirectoryQuery) -> Void) {
        guard let endpointURL = URL.init(string:SchoolDirectoryQuery.endpoint) else {
            DispatchQueue.main.async {
                completion(SchoolDirectoryQuery.init())
            }
            return
        }

        let request = URLRequest.init(url: endpointURL, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 30)
        URLSession.shared.dataTask(with: request, completionHandler: { [completion] (data: Data?, urlRespoinse: URLResponse?, error: Error?) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(SchoolDirectoryQuery.init(data: nil, error: error))
                }
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data) as! [[AnyHashable : Any]]? {
                DispatchQueue.main.async {
                    completion(SchoolDirectoryQuery.init(data: json))
                }
            } else {
                DispatchQueue.main.async {
                    completion(SchoolDirectoryQuery.init(data: nil, error: error))
                }
            }
        }).resume()
    }
    
    // MARK: - Data accessors -
    func schoolName(forIndex index:Int) -> String? {
        return data?[index][Self.schoolNameKey] as? String
    }
    
    func dbn(forIndex index: Int) -> String? {
        return data?[index][Self.dbnKey] as? String
    }
}
