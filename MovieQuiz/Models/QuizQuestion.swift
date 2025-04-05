//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Damir Salakhetdinov on 17/03/25.
//

import Foundation

//создаём структуру QuizQuestion
struct QuizQuestion {
  let image: Data
  let text: String
  // булевое значение (true, false), правильный ответ на вопрос
  let correctAnswer: Bool
}
