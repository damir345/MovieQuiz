//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Damir Salakhetdinov on 18/03/25.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
    func showLoadingIndicator()
    func hideLoadingIndicator()
}
