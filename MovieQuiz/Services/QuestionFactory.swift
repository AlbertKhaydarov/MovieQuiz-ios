//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Альберт Хайдаров on 18.08.2023.
//

import Foundation
class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    // Mock-данные
    private let questions: [QuizQuestion] = [
        QuizQuestion(imageOfFilm: "The Godfather",
                     questionText: "Рейтинг этого фильма\n больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(imageOfFilm: "The Dark Knight",
                     questionText: "Рейтинг этого фильма\n больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(imageOfFilm: "Kill Bill",
                     questionText: "Рейтинг этого фильма\n больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(imageOfFilm: "The Avengers",
                     questionText: "Рейтинг этого фильма\n больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(imageOfFilm: "Deadpool",
                     questionText: "Рейтинг этого фильма\n больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(imageOfFilm: "The Green Knight",
                     questionText: "Рейтинг этого фильма\n больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(imageOfFilm: "Old",
                     questionText: "Рейтинг этого фильма\n больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(imageOfFilm: "The Ice Age Adventures of Buck Wild",
                     questionText: "Рейтинг этого фильма\n больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(imageOfFilm: "Tesla",
                     questionText: "Рейтинг этого фильма\n больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(imageOfFilm: "Vivarium",
                     questionText: "Рейтинг этого фильма\n больше чем 6?",
                     correctAnswer: false)]
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
}


