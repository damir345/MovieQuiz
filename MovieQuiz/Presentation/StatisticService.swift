//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Damir Salakhetdinov on 19/03/25.
//

import Foundation

final class StatisticServiceImplementation: StatisticServiceProtocol {

    private enum Keys: String {
        case correctAnswers
        case totalQuestions
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
    }

    private var storage: UserDefaults

    init(storage: UserDefaults = .standard) {
        self.storage = storage
    }

    private var correctAnswers: Int {
        get {
            return storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }

    private var totalQuestions: Int {
        get {
            return storage.integer(forKey: Keys.totalQuestions.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestions.rawValue)
        }
    }

    internal var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }

    var totalAccuracy: Double {
        get {
            guard totalQuestions > 0 else { return 0.0 }
            return (Double(correctAnswers) / Double(totalQuestions)) * 100
        }
    }

    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }

    // Функция сохранения лучшего результата
    func store(correct count: Int, total amount: Int) {
        // Обновляем общий счётчик правильных ответов и вопросов
        correctAnswers += count
        totalQuestions += amount

        // Проверяем, лучше ли текущий результат, чем сохраненный
        let currentGameResult = GameResult(correct: count, total: amount, date: Date())
        
        if currentGameResult.correct > bestGame.correct {
            bestGame = currentGameResult
        }

        // Обновляем общее количество игр
        gamesCount += 1
    }
    
    func resetStatistics() {
        storage.removeObject(forKey: Keys.correctAnswers.rawValue)
        storage.removeObject(forKey: Keys.totalQuestions.rawValue)
        storage.removeObject(forKey: Keys.gamesCount.rawValue)
        storage.removeObject(forKey: Keys.bestGameCorrect.rawValue)
        storage.removeObject(forKey: Keys.bestGameTotal.rawValue)
        storage.removeObject(forKey: Keys.bestGameDate.rawValue)

        // Устанавливаем начальные значения
        correctAnswers = 0
        totalQuestions = 0
        gamesCount = 0
        bestGame = GameResult(correct: 0, total: 0, date: Date())
    }
}

