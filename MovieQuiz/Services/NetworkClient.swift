//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Альберт Хайдаров on 31.08.2023.
//

import Foundation

enum NetworkError: Error {
    case codeError
    case invalidURL
}


protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkClient: NetworkRouting {
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(error))
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data = data else {return}
            handler(.success(data))
        }
        
        task.resume()
    }
}
