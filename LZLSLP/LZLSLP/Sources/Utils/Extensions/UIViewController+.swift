//
//  UIViewController+.swift
//  LZLSLP
//
//  Created by user on 8/30/24.
//

import UIKit

extension UIViewController {
    func setNewViewController(nextViewController: UIViewController, isNavigation: Bool) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        var newRootViewController: UIViewController
        if isNavigation {
            newRootViewController = UINavigationController(rootViewController: nextViewController)
        } else {
            newRootViewController = nextViewController
        }
        
        sceneDelegate?.window?.rootViewController = newRootViewController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}

extension UIViewController {
    func showAlert(title: String, message: String, action: @escaping ()->Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
//        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            action()
        }
        
        ac.addAction(action)
        
        self.present(ac, animated: true)
    }
}
