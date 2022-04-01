//
//  AlertManager.swift
//  TikTok
//
//  Created by Shivam Rishi on 24/03/22.
//

import Foundation
import UIKit

struct AlertManager {
    static func present(title:String?,
                        message:String?,
                        style:UIAlertController.Style = .alert,
                        actions:Action...,
                        from controller:UIViewController) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: style)
        for action in actions {
            alert.addAction(action.alertAction)
        }
        controller.present(alert, animated: true)
    }
}

extension AlertManager {
    enum Action {
        case signOut(handler: (() -> Void)?)
        case dismiss
        case cancel
        
        private var title:String {
            switch self {
            case .signOut:
                return "Sign Out"
            case .dismiss:
                return "dismiss"
            case .cancel:
                return "Cancel"
            }
        }
        
        private var style:UIAlertAction.Style {
            switch self {
            case .signOut:
                return .destructive
            case .dismiss,.cancel:
                return .cancel
//            default:
//                return .default
            }
        }
        
        private var handler:(() -> Void)? {
            switch self {
            case .signOut(let handler):
                return handler
            case .dismiss,.cancel:
                return nil
            }
        }
        
        var alertAction: UIAlertAction {
            return UIAlertAction(title: title,
                                 style: style) { _ in
                if let handler = self.handler {
                    handler()
                }
            }
        }
        
    }
    
}
