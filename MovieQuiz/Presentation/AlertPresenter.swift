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
    
    func showAlert(alertMessages: AlertModel, on viewController: UIViewController) {
        let alert = UIAlertController(title: alertMessages.title,
                                      message: alertMessages.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertMessages.buttonText, style: .default) { [weak self] _ in
            guard let self = self else {return}
            alertMessages.alertButtonAction()
            self.delegate?.finishShowAlert()
        }
        
        alert.addAction(action)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
