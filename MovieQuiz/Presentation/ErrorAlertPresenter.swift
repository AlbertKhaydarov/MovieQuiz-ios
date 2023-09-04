//
//  ErrorAlertPresenter.swift
//  MovieQuiz
//
//  Created by Альберт Хайдаров on 31.08.2023.
//

import UIKit

final class ErrorAlertPresenter: ErrorAlertPresenterProtocol {
    
    weak var delegate: ErrorAlertPresenterDelegate?
    
    init(delegate: ErrorAlertPresenterDelegate?) {
        self.delegate = delegate
    }
    
    func errorShowAlert(errorMessages: ErrorAlertModel, on viewController: UIViewController) {
        let alert = UIAlertController(title: errorMessages.title,
                                      message: errorMessages.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: errorMessages.buttonText, style: .default) { [weak self] _ in
            guard let self = self else {return}
            
            errorMessages.errorAlertButtonAction()
            self.delegate?.errorShowAlert()
        }
        
        alert.addAction(action)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
