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
        
        // Support for ipad
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = controller.view
            popoverController.sourceRect = CGRect(
                x: controller.view.bounds.midX,
                y: controller.view.bounds.midY,
                width: 0,
                height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        controller.present(alert, animated: true)
    }
}

extension AlertManager {
    enum Action {
        case yes(handler: (() -> Void)?)
        case delete(handler: (() -> Void)?)
        case unlock(handler: (() -> Void)?)
        case dismiss
        case ok
        case cancel
        
        private var title:String {
            switch self {
            case .yes:
                return "Yes"
            case .delete:
                return "Delete"
            case .unlock:
                return "Unlock"
            case .dismiss:
                return "dismiss"
            case .ok:
                return "Ok"
            case .cancel:
                return "Cancel"
            }
        }
        
        private var style:UIAlertAction.Style {
            switch self {
            case .delete:
                return .destructive
            case .dismiss,.cancel,.ok:
                return .cancel
            default:
                return .default
            }
        }
        
        private var handler:(() -> Void)? {
            switch self {
            case .yes(let handler):
                return handler
            case .delete(let handler):
                return handler
            case .dismiss,.cancel,.ok:
                return nil
            case .unlock(let handler):
                return handler
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
