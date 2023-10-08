//
//  GameRecord.swift
//  MovieQuiz
//

import Foundation

struct GameRecord: Codable {// decodable+encodable
    let correct: Int
    let total: Int
    let date: Date
    // метод сравнения по кол-ву верных ответов
    func isBetterThen(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}
