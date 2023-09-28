import UIKit


final class MovieQuizViewController: UIViewController{
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    //    private var questionFactory: QuestionFactoryProtocol?
//    private var alertPresenter: ResultAlertPresenterProtocol?
//    private var errorPresenter: ErrorAlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        presenter.viewController = self
//
        presenter = MovieQuizPresenter(viewController: self)
        //        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        activityIndicator.hidesWhenStopped = true
        
        //        questionFactory?.loadData()
        
        //        showLoadingIndicator()
        
//        alertPresenter = ResultAlertPresenter(delegate: self)
//        
//        errorPresenter = ErrorAlertPresenter(delegate: self)
        
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
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        let errorModel = ErrorAlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз")
        {  [weak self] in
            guard let self = self else {return}
            self.hideLoadingIndicator()
        }
        presenter.errorPresenter?.errorShowAlert(errorMessages: errorModel, on: self)
    }
    
    func show(resultMessages: ResultAlertModel) {
        presenter.alertPresenter?.showAlert(resultMessages: resultMessages, on: self)
    }
    
    func showAnswerResult(isCorrect: Bool) {
        
        presenter.didCorrectAnswer(isCorrect: isCorrect)
        
        setupBorder(cornerRadius: 20, borderWidth: 8)
        
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor :  UIColor.ypRed.cgColor
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            //            self.presenter.questionFactory = self.questionFactory
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

//// MARK: - QuestionFactoryDelegate
//extension MovieQuizViewController { //}: QuestionFactoryDelegate {
//    func didReceiveNextQuestion(question: QuizQuestion?) {
//        presenter.didReceiveNextQuestion(question: question)
//    }
//
//    func didFailToLoadData(with error: Error) {
//        showNetworkError(message: error.localizedDescription)
//    }
//    func errorInLoadData(with error: String) {
//        showNetworkError(message: error)
//    }
//
//    func didLoadDataFromServer() {
//        hideLoadingIndicator()
//        questionFactory?.requestNextQuestion()
//    }
//}

//// MARK: - AlertPresenterDelegate
//extension MovieQuizViewController: ResultAlertPresenterDelegate, ErrorAlertPresenterDelegate  {
//    func errorShowAlert() {
//        self.showLoadingIndicator()
//        presenter.restartGame()
//    }
//    
//    func finishShowAlert() {
//        presenter.restartGame()
//    }
//}
