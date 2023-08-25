import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var yesButton: UIButton!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 2
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticServiceImplementation: StatisticService?
    private var statisticData: GameRecord? = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        
        questionFactory?.requestNextQuestion()
        
        alertPresenter = AlertPresenter(delegate: self)
        
        statisticServiceImplementation = StatisticServiceImplementation()
        
        setupBorder(cornerRadius: 20, borderWidth: 0)
    }
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {return}
        let qivenAnswer = true
        showAnswerResult(isCorrect: qivenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {return}
        let qivenAnswer = false
        showAnswerResult(isCorrect: qivenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Private functions
    
//    private func show(quiz result: QuizResultsViewModel) {
    private func show(alertNotes: AlertModel, quiz result: QuizResultsViewModel) {
          
        alertPresenter?.showAlert(alertNotes: alertNotes, on: self)

        }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, Вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из \(questionsAmount), попробуйте еще раз!"
            
            let statisticText = """
                    Ваш результат: \(correctAnswers)/\(questionsAmount)
                    Количество сыгранных квизов: 1
                    Рекорд: 6/10 (03.07.22 03:22)
                    Средняя точность: 60.00%
                    """

            let viewModel = QuizResultsViewModel(
                alertTitle: "Этот раунд окончен!",
                resultText: text,
                alertButtonText: "Сыграть еще раз")
            
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: statisticText,
                buttonText: "Сыграть еще раз")
            {
                self.questionFactory?.requestNextQuestion()
            }
            show(alertNotes: alertModel, quiz: viewModel)
            statisticData += 1
            
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()

        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        setupBorder(cornerRadius: 20, borderWidth: 8)
        
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor :  UIColor.ypRed.cgColor
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: "\(model.imageOfFilm)") ?? UIImage(),
            question: model.questionText,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
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
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - AlertPresenterDelegate
    func finishShowAlert() {
        self.currentQuestionIndex = 0
        self.correctAnswers = 0
    }
}
