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
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            //            guard let self = self else { return }
            alertModel.buttonAction()
        }
        
        alert.addAction(action)
        
        viewControllerDelegate?.present(alert, animated: true)
        //        self.present(alert, animated: true, completion: nil)
    }
}
