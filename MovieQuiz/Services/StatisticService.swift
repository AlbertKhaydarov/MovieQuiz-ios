//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Admin on 24.08.2023.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get } 
}

final class StatisticServiceImplementation: StatisticService {
}


