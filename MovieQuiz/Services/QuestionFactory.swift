//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Альберт Хайдаров on 18.08.2023.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
  
    private let moviesLoader: MoviesLoading
    weak private var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading,delegate: QuestionFactoryDelegate) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    private var movies: [MostPopularMovie] = []
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
            
            let rating = Float(movie.rating) ?? 0
            let ratingIndex = (3...7).randomElement() ?? 7
            let text = "Рейтинг этого фильма больше чем \(ratingIndex)?"
            let correctAnswer = rating > Float(ratingIndex)
            
            let question = QuizQuestion(imageOfFilm: imageData,
                                        questionText: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
