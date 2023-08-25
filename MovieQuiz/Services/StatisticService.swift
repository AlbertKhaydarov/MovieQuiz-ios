//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Admin on 24.08.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get } 
}

final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private var privateTotalAccuracy: Double = 0
    private var privateGamesCount: Int = 0
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        get {
            return privateTotalAccuracy
        }
        set {
            privateTotalAccuracy = newValue / Double(gamesCount)
        }
    }
    
    var gamesCount: Int {
        get {
            return privateGamesCount
        }
        set {
            let count = 
            privateGamesCount = newValue
        }
    }
    
    var bestGame: GameRecord{
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
        
        let bestRecord = bestGame
        
        if bestRecord < record {
            print("true")
        }
    }
}

