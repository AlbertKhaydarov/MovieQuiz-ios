//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Альберт Хайдаров on 18.08.2023.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
  
    private enum ComparisonSign: String {
        case more = "больше"
        case less = "меньше"
    }

    
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
            let ratingIndex = (5...8).randomElement() ?? 7
            
            var text: String
            let comparison = (0...1).randomElement() ?? 1
            let correctAnswer: Bool
            
            if comparison == 0 {
                text = "Рейтинг этого фильма \(ComparisonSign.less.rawValue) чем \(ratingIndex)?"
                correctAnswer = rating < Float(ratingIndex) ? true : false
                print(rating)
            } else {
                text = "Рейтинг этого фильма \(ComparisonSign.more.rawValue) чем \(ratingIndex)?"
                correctAnswer = rating > Float(ratingIndex) ? true : false
                print(rating)
            }
            
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
