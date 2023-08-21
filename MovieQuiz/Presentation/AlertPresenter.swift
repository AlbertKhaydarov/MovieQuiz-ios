//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Admin on 21.08.2023.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }
    
    func showAlert(quiz alertNotes: AlertModel, on viewController: UIViewController) {
        let alert = UIAlertController(title: alertNotes.title,
                                      message: alertNotes.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: alertNotes.buttonText, style: .default) { [weak self] _ in
            guard let self = self else {return}
            self.delegate?.finishShowAlert()
            //            alertNotes.onAlertButtonTapped {
            //                self.delegate?.finishShowAlert()
            //            }
        }
        
        alert.addAction(action)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
