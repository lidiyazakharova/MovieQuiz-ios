import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    
    //    private var correctAnswers = 0
    //    private var currentQuestionIndex = 0
    //    private let questionsAmount: Int = 10
    //    private var currentQuestion: QuizQuestion?
    
    //    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter?
    //    private var statisticService: StatisticService?
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        
        //        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        alertPresenter = AlertPresenterImplementation(viewControllerDelegate: self)
        //        statisticService = StatisticServiceImplementation()
        
        showLoadingIndicator()
        //        questionFactory?.loadData()
        
        textLabel.textColor = .clear
        
        
    }
    
    
    //MARK: - QuestionFactoryDelegate
    
    //    func didReceiveNextQuestion(_ question: QuizQuestion?) {
    //        guard let  question = question else {
    //            return
    //        }
    //        currentQuestion = question
    //        let viewModel = presenter.convert(model: question)
    //        DispatchQueue.main.async { [weak self] in
    //            self?.show(quiz: viewModel)
    //        }
    //    }
    
    //    func didReceiveNextQuestion(_ question: QuizQuestion?) {
    //        presenter.didReceiveNextQuestion(question: question)
    //        }
    //
    //    func didFailToLoadData(with error: Error) {
    //        showNetworkError(message: error.localizedDescription)
    //    }
    //
    //    func didLoadDataFromServer() {
    //        activityIndicator.isHidden = true
    //        questionFactory?.requestNextQuestion()
    //    }
    
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        //        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        //        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
    //
    // MARK: - Private functions
    //    private func convert(model: QuizQuestion) -> QuizStepViewModel {
    //        let questionStep = QuizStepViewModel(
    //
    //            image: UIImage(data: model.image) ?? UIImage(),
    //            question: model.text,
    //            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    //
    //        return questionStep
    //    }
    
    func show(quiz step: QuizStepViewModel) {
        textLabel.textColor = .white
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
//    func show(quiz result: QuizResultsViewModel) {
    func show() {
        let message = presenter.makeResultMessage()
        
//        let alert = UIAlertController(
//            title: result.title,
//            message: message,
//            preferredStyle: .alert)
//
//        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
//            guard let self = self else { return }
            
            let alert = AlertModel(title: "Этот раунд окончен!",
                                   message: message,
                                   buttonText: "Сыграть ещё раз") { [weak self] in
                guard let self = self else { return }
                
            self.presenter.restartGame()
        }

//        alert.addAction(action)
//
//        self.present(alert, animated: true, completion: nil)
        alertPresenter?.show(alertModel: alert)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    func changeAfterClicked() {
    imageView.layer.borderWidth = 0
    yesButton.isEnabled = true
    noButton.isEnabled = true
}
    //    func showAnswerResult(isCorrect: Bool) {
    //        if isCorrect {
    //            correctAnswers += 1
    //        }
    //        imageView.layer.masksToBounds = true
    //        imageView.layer.borderWidth = 8
    //        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    //
    //        yesButton.isEnabled = false
    //        noButton.isEnabled = false
    //
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
    //            guard let self = self else { return }
    //
    //            self.imageView.layer.borderWidth = 0
    //            self.yesButton.isEnabled = true
    //            self.noButton.isEnabled = true
    //
    //            self.showNextQuestionOrResults()
    //        }
    //    }
    
    //    private func showNextQuestionOrResults() {
    ////        if currentQuestionIndex == questionsAmount - 1
    //        if presenter.isLastQuestion() {
    //            showFinalResults()
    //        } else {
    ////            currentQuestionIndex += 1
    //            presenter.switchToNextQuestion()
    //            questionFactory?.requestNextQuestion()
    //        }
    //    }
    
    //????
    
    //    func showFinalResults() {
    //        statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
    //
    //        let alertModel = AlertModel(
    //            title: "Этот раунд окончен!",
    //            message: presenter.makeResultMessage(),
    //            buttonText: "Сыграть ещё раз",
    //            buttonAction: { [weak self] in
    ////                self?.currentQuestionIndex = 0
    ////                self?.presenter.resetQuestionIndex()
    ////                self?.correctAnswers = 0
    ////                self?.questionFactory?.requestNextQuestion()
    //                guard let self = self else { return }
    //                self.presenter.restartGame()
    //            }
    //        )
    //
    //        alertPresenter?.show(alertModel: alertModel)
    //    }
    
    
    
    
    //
    //    private func makeResultMessage() -> String {
    //        guard let statisticService = statisticService, let bestGame = statisticService.bestGame else {
    //            assertionFailure("error message")
    //            return ""
    //        }
    //
    //        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
    //        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
    //        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(presenter.questionsAmount)"
    //        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
    //        + " (\(bestGame.date.dateTimeString))"
    //        let averageAccuracyLine = "Средняя точность: \(accuracy)%"
    //
    //        let resultMessage = [
    //            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine].joined(separator: "\n")
    //        return resultMessage
    //    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }

            //            self.currentQuestionIndex = 0
            //            self.presenter.resetQuestionIndex()
            //            self.correctAnswers = 0
            //
            //            self.questionFactory?.requestNextQuestion()
            self.presenter.startLoadData()
        }

        alertPresenter?.show(alertModel: alert)
    }
//        let alert = UIAlertController(
//                    title: "Ошибка",
//                    message: message,
//                    preferredStyle: .alert)
//
//        let action = UIAlertAction(title: "Попробовать ещё раз",
//                    style: .default) { [weak self] _ in
//                        guard let self = self else { return }
//
//                        self.presenter.restartGame()
//                    }
//
//                alert.addAction(action)
//            }
}

