//
//  File.swift
//  
//
//  Created by Samuel Tsokwa on 2021-08-31.
import Foundation
import SwiftUI

public class HostingController<Content: View>: UIHostingController<Content> {
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIApplication.statusBarStyle
    }
}

///By wrapping views in a RootView, they will become the app's main / primary view. This will enable setting the statusBarStyle.
public struct DefaultRootView<Content: View>: View {
    public var content: Content
    
    public init(@ViewBuilder content: () -> (Content)) {
        self.content = content()
    }
    
    public var body: some View {
        EmptyView()
            .onAppear {
                UIApplication.shared.setHostingController(rootView: AnyView(content))
            }
    }
}

public extension View {
    ///Sets the status bar style color for this view.
    public func statusBarStyle(_ style: UIStatusBarStyle) -> some View {
        UIApplication.statusBarStyleHierarchy.append(style)
        //Once this view appears, set the style to the new style. Once it disappears, set it to the previous style.
        return self.onAppear {
            UIApplication.setStatusBarStyle(style)
        }.onDisappear {
            guard UIApplication.statusBarStyleHierarchy.count > 1 else { return }
            let style = UIApplication.statusBarStyleHierarchy[UIApplication.statusBarStyleHierarchy.count - 1]
            UIApplication.statusBarStyleHierarchy.removeLast()
            UIApplication.setStatusBarStyle(style)
        }
    }
}

public extension UIApplication {
    public static var hostingController: HostingController<AnyView>? = nil
    
    public static var statusBarStyleHierarchy: [UIStatusBarStyle] = []
    public static var statusBarStyle: UIStatusBarStyle = .darkContent
    
    ///Sets the App to start at rootView
    public func setHostingController(rootView: AnyView) {
        let hostingController = HostingController(rootView: AnyView(rootView))
        windows.first?.rootViewController = hostingController
        UIApplication.hostingController = hostingController
    }
    
    public static func setStatusBarStyle(_ style: UIStatusBarStyle) {
        statusBarStyle = style
        hostingController?.setNeedsStatusBarAppearanceUpdate()
    }
    
    public static func getStatusBarStyle() -> UIStatusBarStyle {
        return statusBarStyle
    }
}

