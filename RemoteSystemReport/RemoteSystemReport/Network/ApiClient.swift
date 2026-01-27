//
//  ApiClient.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 24/01/26.
//

import Foundation


final class ApiClient {
    static let shared = ApiClient()
    private init() {}
    
    private let baseurl = EnvironmentSetup.baseUrl
    
    func request<T: Decodable>(
        path: String,
        method: String = "GET",
        body: [String: Any]? = nil,
        query: [URLQueryItem] = [],
        completion: @escaping(Result<T,Error>) -> Void
    ){
        
        var component = URLComponents(string: baseurl + path)!
        component.queryItems = query
        
        var request = URLRequest(url: component.url!)
        request.httpMethod = method
        
        request.setValue(
            "Bearer \(TokenStore.shared.jwt ?? "")"
            , forHTTPHeaderField: "Authorization"
        )
        
        if let body = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else{return}
            
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            do {
                let decoded = try decoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
            
        }
        .resume()
        
    }
}
