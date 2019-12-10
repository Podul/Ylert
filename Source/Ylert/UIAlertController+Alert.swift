//
//  UIAlertController+Alert.swift
//  Pods-Ylert_Example
//
//  Created by Podul on 2019/11/9.
//

import UIKit


public typealias AlertActionHandler = (UIAlertAction) -> Void
public typealias TextFieldHandler = (UITextField) -> Void

/// 持有 alertMaker 对象，不让它提前释放
private var _maker: AlertMaker? = nil


private class AlertAction {
    let style: UIAlertAction.Style
    let title: String
    var handler: AlertActionHandler!
    
    deinit {
        print("alertaction is deinit")
    }
    
    init(style: UIAlertAction.Style, title: String, handler: @escaping AlertActionHandler) {
        self.style = style
        self.title = title
        self.handler = handler
    }
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
                self.dismiss(alertVC)
            }
            alertVC.addAction(action)
        }
        
//        DispatchQueue.main.async {
            self.present(alertVC)
//        }
    }
    
}

extension AlertMaker {
    private static let alertWindow: UIWindow = {
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
    
    // MARK: - Window
    private func showWindow() {
        if #available(iOS 13.0, *) {
            let connectedScenes = UIApplication.shared.connectedScenes;
            let scene = connectedScenes.filter { $0.activationState == .foregroundActive }.first
            if let windowScene = scene as? UIWindowScene {
                AlertMaker.alertWindow.windowScene = windowScene
            }
        }
        AlertMaker.alertWindow.isHidden = false
    }
    
    private func hideWindow() {
        AlertMaker.alertWindow.isHidden = true
    }
    
    // MARK: - Controller
    private func present(_ alertController: UIAlertController) {
        showWindow()
        AlertMaker.alertWindow.rootViewController?.present(alertController, animated: true)
    }
    
    private func dismiss(_ alertController: UIAlertController) {
        alertController.dismiss(animated: true)
        self.textFieldHandlers.removeAll()
        self.alertActions.removeAll()
        self.hideWindow()
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

