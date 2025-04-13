import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - Свойства и переменные
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var buttonNo: UIButton!
    @IBOutlet weak private var buttonYes: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!

        // MARK: - Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()
            
            presenter = MovieQuizPresenter(viewController: self)

            label.font = UIFont(name: "YSDisplay-Medium", size: 20)
            counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
            textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
            buttonYes.tintColor = UIColor(named: "YP Black")
            buttonNo.tintColor = UIColor(named: "YP Black")
            buttonNo.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
            buttonYes.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.cornerRadius = 20
            imageView.layer.borderColor = UIColor.clear.cgColor
            imageView.layer.cornerRadius = 20
        }

        // MARK: - Actions

        @IBAction private func yesButtonClicked(_ sender: UIButton) {
            presenter.yesButtonClicked()
        }

        @IBAction private func noButtonClicked(_ sender: UIButton) {
            presenter.noButtonClicked()
        }

        // MARK: - Private functions

        func show(quiz step: QuizStepViewModel) {
            imageView.layer.borderColor = UIColor.clear.cgColor
            imageView.image = step.image
            textLabel.text = step.question
            counterLabel.text = step.questionNumber
        }

        func show(quiz result: QuizResultsViewModel) {
            let message = presenter.makeResultsMessage()

            let alert = UIAlertController(
                title: result.title,
                message: message,
                preferredStyle: .alert)

                let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                    guard let self = self else { return }

                    self.presenter.restartGame()
                }

            alert.addAction(action)

            self.present(alert, animated: true, completion: nil)
        }

        func highlightImageBorder(isCorrectAnswer: Bool) {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        }

        func showLoadingIndicator() {
            activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
            activityIndicator.startAnimating() // включаем анимацию
        }

        func hideLoadingIndicator() {
            activityIndicator.isHidden = true
        }

        func showNetworkError(message: String) {
            hideLoadingIndicator()

            let alert = UIAlertController(
                title: "Ошибка",
                message: message,
                preferredStyle: .alert)

                let action = UIAlertAction(title: "Попробовать ещё раз",
                style: .default) { [weak self] _ in
                    guard let self = self else { return }

                    self.presenter.restartGame()
                }

            alert.addAction(action)
        }
    }

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
