//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Admin on 18.08.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
    func errorInLoadData(with error: String)
}
