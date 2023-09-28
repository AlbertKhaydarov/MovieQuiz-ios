//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Admin on 28.09.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(resultMessages: ResultAlertModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
}
