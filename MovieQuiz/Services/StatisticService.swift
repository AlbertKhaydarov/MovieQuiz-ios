//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Admin on 24.08.2023.
//

import Foundation

final class StatisticServiceImplementation: StatisticServiceProtocol {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        get {
            let correct = userDefaults.integer(forKey: Keys.correct.rawValue)
            let total = userDefaults.integer(forKey: Keys.total.rawValue)
            return Double(correct) / Double(total) * 100.0
        }
    }
    
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    private(set) var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        
        let record = GameRecord(correct: count, total: amount, date: Date())
        
        if bestGame < record {
            bestGame = record
        }
        
        let storeCorrect = userDefaults.integer(forKey: Keys.correct.rawValue)
        let correct = storeCorrect + count
        userDefaults.set(correct, forKey: Keys.correct.rawValue)
        
        let storeTotal = userDefaults.integer(forKey: Keys.total.rawValue)
        let total = storeTotal + amount
        userDefaults.set(total, forKey: Keys.total.rawValue)
        
        gamesCount += 1
    }
}

