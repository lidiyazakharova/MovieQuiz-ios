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

//extension GameRecord: Comparable {
//    private var accuracy: Double {
//        guard total != 0 else {
//            return 0
//        }
//        return Double(correct) / Double(total)
//    }
//
//    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
////                lhs.correct < rhs.correct
//        lhs.accuracy < rhs.accuracy
//    }
//}


