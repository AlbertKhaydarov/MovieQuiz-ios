import UIKit


final class MovieQuizViewController: UIViewController{
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
    var correctAnswers: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: ResultAlertPresenterProtocol?
    private var errorPresenter: ErrorAlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    private let presenter = MovieQuizPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewController = self
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        activityIndicator.hidesWhenStopped = true
        
        questionFactory?.loadData()
        
        showLoadingIndicator()
        
        alertPresenter = ResultAlertPresenter(delegate: self)
        
        errorPresenter = ErrorAlertPresenter(delegate: self)
        
        statisticService = StatisticServiceImplementation()
        
        setupBorder(cornerRadius: 20, borderWidth: 0)
    }
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - Private functions
    
    private func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        let errorModel = ErrorAlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз")
        {  [weak self] in
            guard let self = self else {return}
            self.hideLoadingIndicator()
        }
        errorPresenter?.errorShowAlert(errorMessages: errorModel, on: self)
    }
    
    func show(resultMessages: ResultAlertModel) {
        alertPresenter?.showAlert(resultMessages: resultMessages, on: self)
    }
    
    //    private func showNextQuestionOrResults() {
    //        if presenter.isLastQuestion() {
    //            statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
    //            guard let gamesCount = statisticService?.gamesCount else {return}
    //            guard let bestgames = statisticService?.bestGame else {return}
    //            guard let totalAccuracy = statisticService?.totalAccuracy else {return}
    //
    //            let text = """
    //                    Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
    //                    Количество сыгранных квизов: \(gamesCount)
    //                    Рекорд: \(bestgames.correct)/\(bestgames.total) (\(bestgames.date.dateTimeString))
    //                    Средняя точность: \(String(format: "%.2f", totalAccuracy))%
    //                    """
    //
    //            let alertModel = ResultAlertModel(
    //                title: "Этот раунд окончен!",
    //                message: text,
    //                buttonText: "Сыграть еще раз")
    //            { [weak self] in
    //                guard let self = self else {return}
    //                self.questionFactory?.requestNextQuestion()
    //            }
    //            show(resultMessages: alertModel)
    //            presenter.resetQuestionIndex()
    //        } else {
    //            presenter.switchToNextQuestion()
    //            questionFactory?.requestNextQuestion()
    //        }
    //    }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        setupBorder(cornerRadius: 20, borderWidth: 8)
        
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor :  UIColor.ypRed.cgColor
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.presenter.correctAnswers = self.correctAnswers
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
        }
    }
    
    func show(quiz step: QuizStepViewModel) {
        noButton.isEnabled = true
        yesButton.isEnabled = true
        
        setupBorder(cornerRadius: 20, borderWidth: 0)
        
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func setupBorder(cornerRadius: CGFloat, borderWidth: CGFloat) {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.borderWidth = borderWidth
    }
}

// MARK: - QuestionFactoryDelegate
extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    func errorInLoadData(with error: String) {
        showNetworkError(message: error)
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
}

// MARK: - AlertPresenterDelegate
extension MovieQuizViewController: ResultAlertPresenterDelegate, ErrorAlertPresenterDelegate  {
    func errorShowAlert() {
        self.showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    func finishShowAlert() {
        correctAnswers = 0
    }
}
