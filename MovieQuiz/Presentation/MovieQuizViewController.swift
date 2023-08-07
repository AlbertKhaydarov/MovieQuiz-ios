import UIKit

struct QuizQuestion {
    let imageOfFilm: String
    let questionText: String
    let correctAnswer: Bool
}

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizResultsViewModel {
    let alertTitle: String
    let resultText: String
    let alertButtonText: String
}

final class MovieQuizViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    // Mock-данные
    private let questions: [QuizQuestion] = [QuizQuestion(imageOfFilm: "The Godfather",
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
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    let padding = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestion = questions[currentQuestionIndex]
        let currentQuestionViewModel = convert(model: currentQuestion)
        
        show(quiz: currentQuestionViewModel)
        
        setupBorder(cornerRadius: 20, borderWidth: 0)
        }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let qivenAnswer = true
        
        showAnswerResult(isCorrect: qivenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let qivenAnswer = false
        
        showAnswerResult(isCorrect: qivenAnswer == currentQuestion.correctAnswer)
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.alertTitle,
                                      message: result.resultText,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.alertButtonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/\(questions.count)"
            let viewModel = QuizResultsViewModel(
                alertTitle: "Этот раунд окончен!",
                resultText: text,
                alertButtonText: "Сыграть еще раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        setupBorder(cornerRadius: 20, borderWidth: 8)
        
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor :  UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: "\(model.imageOfFilm)") ?? UIImage(),
            question: model.questionText,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        self.setupBorder(cornerRadius: 20, borderWidth: 0)
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func setupBorder(cornerRadius: CGFloat, borderWidth: CGFloat){
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.borderWidth = borderWidth
    }
}
