//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Damir Salakhetdinov on 19/03/25.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    // Проверка, что новый результат лучше старого
    func isBetter(than other: GameResult) -> Bool {
        return correct > other.correct // Можем расширить логику, если нужна дополнительная проверка
    }
}
