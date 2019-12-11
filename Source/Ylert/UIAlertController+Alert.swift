//
//  UIAlertController+Alert.swift
//  Pods-Ylert_Example
//
//  Created by Podul on 2019/11/9.
//

import UIKit


public typealias AlertActionHandler = (_ action: UIAlertAction) -> Void
public typealias TextFieldHandler = (_ textField: UITextField) -> Void

/// 持有 alertMaker 对象，不让它提前释放
private var _maker: AlertMaker? = nil


private struct AlertAction {
    let style: UIAlertAction.Style
    let title: String
    let handler: AlertActionHandler
}

public class AlertMaker {
    fileprivate var title: String? = nil
    fileprivate var message: String? = nil
    fileprivate let style: UIAlertController.Style;
    fileprivate lazy var alertActions = [AlertAction]()
    fileprivate lazy var textFieldHandlers = [TextFieldHandler]()
    
    deinit {
        print("alertmaker deinit")
    }
    fileprivate init(style: UIAlertController.Style = .alert) {
        if #available(iOS 13.0, *) {
            // 有多个 Scenes 时，Window 会出现问题。
            assert(!UIApplication.shared.supportsMultipleScenes, "Not supports Multiple Scenes")
        }
        self.style = style
    }
}

/// Public Function
extension AlertMaker {
    public func title(_ title: String) -> AlertMaker {
        self.title = title
        return self
    }
    
    public func message(_ message: String) -> AlertMaker {
        self.message = message
        return self
    }
    
    public func cancel(_ title: String, handler: @escaping AlertActionHandler = { _ in }) -> AlertMaker {
        let action = AlertAction(style: .cancel, title: title, handler: handler)
        alertActions.append(action)
        return self
    }
    
    public func `default`(_ title: String, handler: @escaping AlertActionHandler = { _ in }) -> AlertMaker {
        let action = AlertAction(style: .default, title: title, handler: handler)
        alertActions.append(action)
        return self
    }
    
    public func destructive(_ title: String, handler: @escaping AlertActionHandler = { _ in }) -> AlertMaker {
        let action = AlertAction(style: .destructive, title: title, handler: handler)
        alertActions.append(action)
        return self
    }
    
    public func textField(_ handler: @escaping TextFieldHandler = { _ in }) -> AlertMaker {
        textFieldHandlers.append(handler)
        return self
    }
}

/// show
extension AlertMaker {
    public func show() {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for handler in textFieldHandlers {
            alertVC.addTextField(configurationHandler: handler)
        }
        
        // actions
        for alertAction in self.alertActions {
            let action = UIAlertAction(title: alertAction.title, style: alertAction.style) {
                alertAction.handler($0)
                self.dismiss()
            }
            alertVC.addAction(action)
        }
        
        DispatchQueue.main.async {
            self.present(alertVC)
        }
    }
    
}


extension AlertMaker {
    
    // MARK: - Controller
    private func present(_ alertController: UIAlertController) {
        AlertWindow.show()
        AlertWindow.shared.rootViewController?.present(alertController, animated: true)
    }
    
    private func dismiss() {
        AlertWindow.shared.rootViewController?.dismiss(animated: true)
        AlertWindow.hide()
        _maker = nil
        
    }
    
}


// MARK: - UIAlertController extension
public extension UIAlertController {
    /// Alert 样式
    static var alert: AlertMaker {
        get {
            _maker = AlertMaker(style: .alert)
            return _maker!
        }
    }
    
    /// ActionSheet 样式
    static func actionSheet() -> AlertMaker {
        _maker = AlertMaker(style: .actionSheet)
        return _maker!
    }
}


// MARK: - AlertWindow
fileprivate struct AlertWindow {
    static let shared: UIWindow = {
        var window: UIWindow
        if #available(iOS 13.0, *) {
            let connectedScenes = UIApplication.shared.connectedScenes;
            let scene = connectedScenes.filter { $0.activationState == .foregroundActive }.first
            if let windowScene = scene as? UIWindowScene {
                window = UIWindow(windowScene: windowScene)
            }else {
                window = UIWindow(frame: UIScreen.main.bounds)
            }
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        window.windowLevel = .alert;
        
        let rootVC = UIViewController()
        rootVC.view.backgroundColor = .clear
        window.rootViewController = rootVC
        return window
    }()
    
    static func show() {
        if #available(iOS 13.0, *) {
            let connectedScenes = UIApplication.shared.connectedScenes;
            let scene = connectedScenes.filter { $0.activationState == .foregroundActive }.first
            if let windowScene = scene as? UIWindowScene {
                shared.windowScene = windowScene
            }
        }
        shared.isHidden = false
    }
    
    static func hide() {
        shared.isHidden = true
    }
}
