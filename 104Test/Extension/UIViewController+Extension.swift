//
//  UIViewController+Extension.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/14.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String? = nil, okActionTitle: String = "確定", handler: ((UIAlertAction) -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionTitle, style: .default, handler: handler)
        alertController.addAction(okAction)

        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String, message: String? = nil, okActionTitle: String = "確定", cancelActionTitle: String = "取消", okHandler: ((UIAlertAction) -> Void)? = nil, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionTitle, style: .default, handler: okHandler)
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel, handler: cancelHandler)
        
        let actions = [okAction, cancelAction]
        
        for action in actions {
            alertController.addAction(action)
        }
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
