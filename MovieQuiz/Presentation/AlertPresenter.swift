//
//  AlertPresenter.swift
//  MovieQuiz
//

import UIKit

protocol AlertPresenter {
    func show(alertModel: AlertModel)
}

final class AlertPresenterImplementation{
    private weak var viewControllerDelegate: UIViewController?
    
    init(viewControllerDelegate: UIViewController? = nil) {
        self.viewControllerDelegate = viewControllerDelegate
    }
}

extension AlertPresenterImplementation: AlertPresenter {
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Game results"
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.buttonAction()
        }
        
        alert.addAction(action)
        
        viewControllerDelegate?.present(alert, animated: true)
    }
}
