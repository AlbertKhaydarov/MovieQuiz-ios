//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Admin on 21.08.2023.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol {
    func showAlert(quiz alertNotes: AlertModel, on: UIViewController)
}
