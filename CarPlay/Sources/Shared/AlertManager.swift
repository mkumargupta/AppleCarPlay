//
//  AlertManager.swift
//  CarPlayDemo
//
//  Created by Apple on 09/05/25.
//

import UIKit
import CarPlay
// MARK: - Shared Alert Manager

// AlertManager.swift
final class AlertManager {
    static let shared = AlertManager()
    
    private init() {}
    
    // iPhone alert
    func showAlert(title: String) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes
                    .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                  let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
                  var topController = keyWindow.rootViewController else {
                return
            }

            // Traverse to the top-most presented view controller
            while let presented = topController.presentedViewController {
                topController = presented
            }

            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    // CarPlay alert
    func showCarPlayAlert(title: String, interfaceController: CPInterfaceController?) {
        guard let interfaceController = interfaceController else { return }

        let action = CPAlertAction(title: "OK", style: .default) { _ in
            interfaceController.dismissTemplate(animated: true, completion: nil)
        }
        let alertTemplate = CPAlertTemplate(titleVariants: [title], actions: [action])

        interfaceController.presentTemplate(alertTemplate, animated: true, completion: nil)
    }
    
    // Show alert on both platforms
    func showCombinedAlert(title: String, interfaceController: CPInterfaceController?) {
        showAlert(title: title)
        showCarPlayAlert(title: title, interfaceController: interfaceController)
    }
}
