//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Admin on 21.08.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var alertButtonAction: () -> Void
    
    func onAlertButtonTapped(completion: @escaping() -> Void){
        completion()
    }
}
