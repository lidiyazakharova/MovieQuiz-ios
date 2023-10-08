import UIKit

struct ViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    private var correctAnswers = 0
    private var currentQuestionIndex = 0
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenterImplementation(viewControllerDelegate: self)
        statisticService = StatisticServiceImplementation()
        
        //        let currentQuestion = questions[currentQuestionIndex]
        //        if let firstQuestion = questionFactory.requestNextQuestion() {
        //            currentQuestion = firstQuestion
        //            let viewModel = convert(model: firstQuestion)
        //            show(quiz: viewModel)
        //        }
        
        questionFactory?.requestNextQuestion()
        
        super.viewDidLoad()
    }
    
    //MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(_ question: QuizQuestion?) {
        guard let  question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        //        let currentQuestion = questions[currentQuestionIndex]
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        //        let currentQuestion = questions[currentQuestionIndex]
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Private functions
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.imageView.layer.borderWidth = 0
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
            
            self.showNextQuestionOrResults()
        }
    }
    
    //    private func showNextQuestionOrResults() {
    //        if currentQuestionIndex == questionsAmount - 1 {
    //            //            let text = "Ваш результат: \(correctAnswers)/10"
    //            let text = correctAnswers == questionsAmount ?
    //            "Поздравляем, вы ответили на 10 из 10!" :
    //            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
    //
    //            let viewModel = QuizResultsViewModel(
    //                title: "Этот раунд окончен!",
    //                text: text,
    //                buttonText: "Сыграть ещё раз")
    //            show(quiz: viewModel)
    //
    //        } else {
    //            currentQuestionIndex += 1
    //
    //            //            let nextQuestion = questions[currentQuestionIndex]
    //            //            if let nextQuestion = questionFactory.requestNextQuestion() {
    //            //                currentQuestion = nextQuestion
    //            //                let viewModel = convert(model: nextQuestion)
    //            //
    //            //                show(quiz: viewModel)
    //            //            }
    //            questionFactory?.requestNextQuestion()
    //        }
    //    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            showFinalResults()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showFinalResults() {
        statisticService?.store(correct: correctAnswers, total: questionsAmount)
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: makeResultMessage(),
            buttonText: "Сыграть еще раз",
            buttonAction: { [weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            }
        )
        
        alertPresenter?.show(alertModel: alertModel)
    }
    
    private func makeResultMessage() -> String {
        //        """
        //        Количество сыгранных квизов: \(statisticService?.gamesCount)
        //        ...
        //        """
        guard let statisticService = statisticService, let bestGame = statisticService.bestGame else {
            assertionFailure("error massege")
            return ""
        }
        
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy) // 3.345687 -> 3.35
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
        + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(accuracy)%"
        
        let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine].joined(separator: "\n")
        return resultMessage
    }
    
    
    
    //        let alert = UIAlertController(
    //            title: result.title,
    //            message: result.text,
    //            preferredStyle: .alert)
    //
    //        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
    //            guard let self = self else { return }
    //
    //            self.currentQuestionIndex = 0
    //            self.correctAnswers = 0
    //
    //            //            let firstQuestion = self.questions[self.currentQuestionIndex]
    ////            if let firstQuestion = self.questionFactory.requestNextQuestion() {
    ////                self.currentQuestion = firstQuestion
    ////                let viewModel = self.convert(model: firstQuestion)
    ////
    ////                self.show(quiz: viewModel)
    ////            }
    //            self.questionFactory?.requestNextQuestion()
    //        }
    //
    //        alert.addAction(action)
    //
    //        self.present(alert, animated: true, completion: nil)
}

