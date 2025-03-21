//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Damir Salakhetdinov on 18/03/25.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
}
