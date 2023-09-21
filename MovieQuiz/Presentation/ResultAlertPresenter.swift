//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Admin on 21.08.2023.
//

import Foundation
import UIKit

class ResultAlertPresenter: ResultAlertPresenterProtocol {
    
    weak var delegate: ResultAlertPresenterDelegate?
    
    init(delegate: ResultAlertPresenterDelegate?) {
        self.delegate = delegate
    }
    
    func showAlert(resultMessages: ResultAlertModel, on viewController: UIViewController) {
        let alert = UIAlertController(title: resultMessages.title,
                                      message: resultMessages.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: resultMessages.buttonText, style: .default) { [weak self] _ in
            guard let self = self else {return}
            
            resultMessages.alertButtonAction()
            self.delegate?.finishShowAlert()
        }
        
        alert.addAction(action)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
