//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Damir Salakhetdinov on 17/03/25.
//

import Foundation

//создаём структуру QuizQuestion
struct QuizQuestion {
  // строка с названием фильма,
  // совпадает с названием картинки афиши фильма в Assets
  let image: String
  // строка с вопросом о рейтинге фильма
  let text: String
  // булевое значение (true, false), правильный ответ на вопрос
  let correctAnswer: Bool
}
