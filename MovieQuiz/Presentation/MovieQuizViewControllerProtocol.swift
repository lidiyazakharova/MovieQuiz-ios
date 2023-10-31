//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    
    func show(quiz step: QuizStepViewModel)
//    func show(quiz result: QuizResultsViewModel)
    func showResult()
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func changeAfterClicked()
    
    func showNetworkError(message: String)
} 
