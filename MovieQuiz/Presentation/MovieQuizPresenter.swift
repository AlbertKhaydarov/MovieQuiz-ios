//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Admin on 26.09.2023.
//

import UIKit

final class MovieQuizPresenter {
    
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 2
    private var correctAnswers: Int = 0
    private var currentQuestion: QuizQuestion?
    
    private weak var viewController: MovieQuizViewController?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol!
    var alertPresenter: ResultAlertPresenterProtocol?
    var errorPresenter: ErrorAlertPresenterProtocol?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
        
        statisticService = StatisticServiceImplementation()
        
        alertPresenter = ResultAlertPresenter(delegate: self)
        errorPresenter = ErrorAlertPresenter(delegate: self)
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.imageOfFilm) ?? UIImage(),
            question: model.questionText,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {return}
        
        let givenAnswer = isYes
        
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func didCorrectAnswer(isCorrect: Bool) {
        correctAnswers += 1
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        
        didCorrectAnswer(isCorrect: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.proceedToNextQuestionOrResults()
        }
    }
    
    func makeResultMessage() -> String {
        statisticService?.store(correct: correctAnswers, total: self.questionsAmount)
        guard let gamesCount = statisticService?.gamesCount,
              let bestgames = statisticService?.bestGame,
              let totalAccuracy = statisticService?.totalAccuracy else {return ""}
        
        let text = """
                Ваш результат: \(correctAnswers)/\(self.questionsAmount)
                Количество сыгранных квизов: \(gamesCount)
                Рекорд: \(bestgames.correct)/\(bestgames.total) (\(bestgames.date.dateTimeString))
                Средняя точность: \(String(format: "%.2f", totalAccuracy))%
                """
        return text
    }
    
    func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            let alertModel = ResultAlertModel(
                title: "Этот раунд окончен!",
                message: makeResultMessage(),
                buttonText: "Сыграть еще раз")
            { [weak self] in
                guard let self = self else {return}
                questionFactory?.requestNextQuestion()
            }
            viewController?.show(resultMessages: alertModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
}
// MARK: - QuestionFactoryDelegate
extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func errorInLoadData(with error: String) {
        viewController?.showNetworkError(message: error)
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
}

// MARK: - AlertPresenterDelegate, ErrorAlertPresenterDelegate
extension MovieQuizPresenter: ResultAlertPresenterDelegate, ErrorAlertPresenterDelegate  {
    func errorShowAlert() {
        viewController?.showLoadingIndicator()
        restartGame()
        questionFactory?.loadData()
    }
    
    func finishShowAlert() {
        restartGame()
    }
}

