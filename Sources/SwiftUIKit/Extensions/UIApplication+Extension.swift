//
//  File.swift
//  
//
//  Created by Samuel Tsokwa on 2021-08-31.
//

import Foundation
import SwiftUI

public extension UIApplication {
    static func resignFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

public extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

public struct ResignKeyboardOnDragGesture: ViewModifier {
    public var gesture = DragGesture().onChanged{_ in
        UIApplication.resignFirstResponder()
    }
    public func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

public extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}

public extension View {
    func resignFirstResponder(on: Binding<Bool>) -> some View {
        if on.wrappedValue {
            UIApplication.resignFirstResponder()
        }
        return self
    }
}

