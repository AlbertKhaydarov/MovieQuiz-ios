//
//  errorAlertModel.swift
//  MovieQuiz
//
//  Created by Альберт Хайдаров on 31.08.2023.
//

import Foundation

struct ErrorAlertModel {
    let title: String
    let message: String
    let buttonText: String
    let errorAlertButtonAction: () -> Void
}
