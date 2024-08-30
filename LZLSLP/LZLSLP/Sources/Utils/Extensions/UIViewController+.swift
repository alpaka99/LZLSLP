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
