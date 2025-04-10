//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Damir Salakhetdinov on 10/04/25.
//

import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func isLastQuestion() -> Bool {
            currentQuestionIndex == questionsAmount - 1
        }
        
    func resetQuestionIndex() {
            currentQuestionIndex = 0
        }
        
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
}
