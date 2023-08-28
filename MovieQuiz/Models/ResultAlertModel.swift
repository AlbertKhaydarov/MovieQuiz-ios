//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Admin on 21.08.2023.
//

import Foundation

struct ResultAlertModel {
    let title: String
    let message: String
    let buttonText: String
    let alertButtonAction: () -> Void
}
