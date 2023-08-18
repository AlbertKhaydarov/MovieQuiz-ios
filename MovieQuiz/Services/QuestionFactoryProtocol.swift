//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Admin on 18.08.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion() -> QuizQuestion?
}
