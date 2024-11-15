//
//  APIService.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/10/24.
//

import Foundation

struct APIService<T: Decodable> {
    
    func getDataFromRemote(endPoint: String) async throws -> T {
        
        guard let url = URL(string: endPoint) else { throw GHError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let respose = response as? HTTPURLResponse, respose.statusCode == 200 else {
            throw GHError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
    
    enum GHError: Error {
        case invalidURL
        case invalidResponse
        case invalidData
    }
}
