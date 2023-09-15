//
//  Structures.swift
//  MovieQuiz
//
//  Created by Пользователь on 15.09.2023.
//

import UIKit

struct ViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

