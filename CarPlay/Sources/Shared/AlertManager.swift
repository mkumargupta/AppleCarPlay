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
    
    private var isCarPlayAlertShowing = false
    private init() {}
    
    // iPhone alert
    func showAlert(title: String) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes
                .first(where: {
                    ($0.activationState == .foregroundActive || $0.activationState == .foregroundInactive)
                    && $0 is UIWindowScene
                }) as? UIWindowScene else {
                print("No active window scene")
                return
            }

            guard let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) ?? windowScene.windows.first,
                  var topController = keyWindow.rootViewController else {
                // Retry after a small delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.showAlert(title: title)
                }
                return
            }

            while let presented = topController.presentedViewController {
                topController = presented
            }

            guard !topController.isBeingPresented && !topController.isBeingDismissed else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.showAlert(title: title)
                }
                return
            }

            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            topController.present(alert, animated: true)
        }
    }
    
    // CarPlay alert
    func showCarPlayAlert(title: String, interfaceController: CPInterfaceController?) {
        guard let interfaceController = interfaceController else { return }

        let presentAlert = {
            let action = CPAlertAction(title: "OK", style: .default) { _ in
                interfaceController.dismissTemplate(animated: true, completion: nil)
                self.isCarPlayAlertShowing = false
            }

            let alertTemplate = CPAlertTemplate(titleVariants: [title], actions: [action])
            interfaceController.presentTemplate(alertTemplate, animated: true) { _, _ in
                self.isCarPlayAlertShowing = true
            }
        }

        if isCarPlayAlertShowing {
            interfaceController.dismissTemplate(animated: true) { _,_  in
                self.isCarPlayAlertShowing = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    presentAlert()
                }
            }
        } else {
            presentAlert()
        }
    }
    
    // Show alert on both platforms
    func showCombinedAlert(title: String, interfaceController: CPInterfaceController?) {
        showAlert(title: title)
        showCarPlayAlert(title: title, interfaceController: interfaceController)
    }
}
