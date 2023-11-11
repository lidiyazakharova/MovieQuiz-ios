//
//  StatisticService.swift
//  MovieQuiz
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord? { get }
    
    func store(correct: Int, total: Int)
}


final class StatisticServiceImplementation {
    private enum Keys: String {
        case correct, total, bestGame, gameCount
    }
    
    private let userDefaults: UserDefaults
    private let dateProvider: () -> Date
    
    init(
        userDefaults: UserDefaults = .standard,
        dateProvider: @escaping () -> Date = { Date() }
    ) {
        self.userDefaults = userDefaults
        self.dateProvider = dateProvider
    }
}


extension StatisticServiceImplementation: StatisticService {
    
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get{
            userDefaults.integer(forKey: Keys.gameCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gameCount.rawValue)
        }
    }
    
    var bestGame: GameRecord? {
        get {
            guard
                let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let  bestGame = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return bestGame
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        Double(correct) / Double(total) * 100
    }
    
    func store(correct count: Int, total amount: Int) {
        self.correct += count
        self.total += amount
        self.gamesCount += 1
        
        let date = dateProvider()
        let currentGameRecord = GameRecord(correct: count, total: amount, date: date)
        
        if let previousGameRecord = bestGame {
            if currentGameRecord.isBetterThen(previousGameRecord) {
                bestGame = currentGameRecord
            }
        } else {
            bestGame = currentGameRecord
        }
    }
}
