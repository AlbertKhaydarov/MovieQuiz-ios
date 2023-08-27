//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Admin on 21.08.2023.
//

import Foundation
import UIKit

protocol ResultAlertPresenterProtocol {
    func showAlert(alertMessages: ResultAlertModel, on: UIViewController)
}
