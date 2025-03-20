//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Damir Salakhetdinov on 19/03/25.
//

import Foundation

protocol StatisticServiceProtocol {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameResult { get }

    func store(correct count: Int, total amount: Int)
    func resetStatistics()
}
