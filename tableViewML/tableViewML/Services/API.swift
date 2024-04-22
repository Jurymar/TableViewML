//
//  API.swift
//  tableViewML
//
//  Created by Jurymar Colmenares on 27/03/24.
//

import Foundation

import Foundation

class APIService {
    static func searchProducts(with searchTerm: String, completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let searchTermEncoded = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        guard let url = URL(string: "https://api.mercadolibre.com/sites/MLC/search?q=\(searchTermEncoded)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "Error desconocido", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                completion(.success(searchResponse.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
