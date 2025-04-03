import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Свойства и переменные
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var buttonNo: UIButton!
    @IBOutlet weak private var buttonYes: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    // переменная с индексом текущего вопроса, начальное значение 0
    // (по этому индексу будем искать вопрос в массиве, где индекс первого элемента 0, а не 1)
    private var currentQuestionIndex = 0
    // переменная со счётчиком правильных ответов, начальное значение закономерно 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    
//    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private lazy var questionFactory: QuestionFactoryProtocol = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
    
    private var alertPresenter: AlertPresenter?
    
    private var currentQuestion: QuizQuestion?
    
    // Объявляем свойство протокола
    var statisticService: StatisticServiceProtocol!
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Инициализация StatisticService
        statisticService = StatisticServiceImplementation()
        
        // Сброс статистики
        //statisticService.resetStatistics()
        
        alertPresenter = AlertPresenter(viewController: self)
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)

        showLoadingIndicator()
        questionFactory.loadData()
//        let questionFactory = QuestionFactory()
//        questionFactory.setup(delegate: self)
//        self.questionFactory = questionFactory
//        
//        // Фабрика возвращает опционал; прежде чем пытаться отобразить вопрос, нужно убедиться, что он есть. Поэтому мы распаковываем его, и если фабрика возвращает не nil — начинаем отображать. Заменим строки кода конструкцией:
//        questionFactory.requestNextQuestion()
        
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
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    // MARK: - Обработчики действий
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true // 2
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer) // 3
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false // 2
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer) // 3
    }
    
    // MARK: - Приватные вспомогательные методы
    // приватный метод конвертации, который принимает моковый вопрос и возвращает вью модель для главного экрана
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // приватный метод для показа результатов раунда квиза
    // принимает вью модель QuizResultsViewModel и ничего не возвращает
    private func show(quiz result: QuizResultsViewModel) {
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let bestGame = statisticService.bestGame
        let dateFormatted = bestGame.date.dateTimeString
        
        let message = """
        Ваш результат: \(correctAnswers) из \(questionsAmount)
        Количество сыгранных квизов: \(statisticService.gamesCount)
        Рекорд: \(bestGame.correct) из \(bestGame.total) (\(dateFormatted))
        Средняя точность: \(accuracy)%
        """
        
        // Создаем AlertModel с нужными параметрами
        let alert = AlertModel(
            title: "Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть ещё раз"
        ) { [weak self] in
            guard let self = self else { return }
            self.restartGame() // Перезапуск игры
        }
        
        // Используем alertPresenter для отображения алерта
        alertPresenter?.showAlert(model: alert)
    }
    
    
    private func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory.requestNextQuestion() // Запрашиваем новый вопрос
    }
    
    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        //выключение кнопок до началы смены вопроса
        buttonYes.isEnabled = false
        buttonNo.isEnabled = false
        if isCorrect { // 1
            correctAnswers += 1 // 2
        }
        
        imageView.layer.borderColor = isCorrect ? UIColor(named:"YP Green")?.cgColor : UIColor(named: "YP Red")?.cgColor
        // С помощью тернарного условного оператора красим рамку в нужный цвет в зависимости от ответа пользователя.
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in // слабая ссылка на self
            guard let self = self else { return } // разворачиваем слабую ссылку
            // код, который мы хотим вызвать через 1 секунду
            self.showNextQuestionOrResults()
            //включение кнопок
            self.buttonYes.isEnabled = true
            self.buttonNo.isEnabled = true
        }
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        imageView.layer.borderColor = UIColor.clear.cgColor
        if currentQuestionIndex == questionsAmount - 1 {
            // Сохраняем результаты квиза
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            let viewModel = QuizResultsViewModel( // 2
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            
            show(quiz: viewModel) // 3
        } else {
            currentQuestionIndex += 1
            self.questionFactory.requestNextQuestion()
        }
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true // Скрываем индикатор
        activityIndicator.stopAnimating() // Останавливаем анимацию
    }

    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory.requestNextQuestion()
        }
        
        alertPresenter?.showAlert(model: model)
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
