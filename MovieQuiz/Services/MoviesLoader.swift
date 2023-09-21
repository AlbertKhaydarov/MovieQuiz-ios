//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Альберт Хайдаров on 01.09.2023.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "imdb-api.com"
        components.path = "/en/API/Top250Movies/k_zcuw1ytf"
        return components.url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        
        guard let url = mostPopularMoviesUrl else {return handler(.failure(NetworkError.invalidURL))}
        
        networkClient.fetch(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
