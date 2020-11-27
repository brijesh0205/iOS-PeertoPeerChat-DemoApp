//
//  UIView+Extensions.swift
//  FacebookFeedDemo
//
//  Created by Brijesh Singh on 24/11/20
//  Copyright © 2020 Brijesh Singh. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    static func showAlertMessage(_ title : String?, _ message: String?, _ viewController: UIViewController) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertMessage(_ title : String?, _ message: String?, _ buttons: [String]?, _ viewController: UIViewController, completion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        if buttons == nil {
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        }
        else {
            for buttonTitle in buttons ?? [] {
                let action = UIAlertAction.init(title: buttonTitle, style: .default, handler: completion)
                alert.addAction(action)
            }
        }
        viewController.present(alert, animated: true, completion: nil)
    }
}
