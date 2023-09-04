//
//  ErrorAlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Альберт Хайдаров on 31.08.2023.


import UIKit

protocol ErrorAlertPresenterProtocol {
    func errorShowAlert(errorMessages: ErrorAlertModel, on viewController: UIViewController)
}
