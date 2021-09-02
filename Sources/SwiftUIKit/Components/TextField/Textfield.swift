//
//  File.swift
//  
//
//  Created by Samuel Tsokwa on 2021-08-31.
//

import Foundation
import UIKit
import SwiftUI



public struct TextfieldWithoutBorder : UIViewRepresentable {

    public var text: Binding<String>
    public var placeholder: String
    public var textColor: UIColor
    public var keyboardType: UIKeyboardType
    public var isFirstResponder: Bool = false
    public var isSecureTextField: Bool
    public var textAlignment: NSTextAlignment
        
    public init(text: Binding<String>, placeholder: String, keyboardType: UIKeyboardType = .default, isFirstResponder: Bool = false, isSecureTextField: Bool = false, textAlignment: NSTextAlignment = .left, textColor: UIColor = .black) {
        
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.textColor = textColor
        self.isFirstResponder = isFirstResponder
        self.isSecureTextField = isSecureTextField
        self.textAlignment = textAlignment
        self.text = text
    }
    
    
    public func makeCoordinator() -> Coordinator
    {
        return Coordinator(text)
    }

    public class Coordinator: NSObject, UITextFieldDelegate {
            var text: Binding<String>
            var didBecomeFirstResponder = false

        public init(_ text: Binding<String>) {
                    self.text = text
                }
            
//            func textFieldDidEndEditing(_ textField: UITextField) {
//                self.text.wrappedValue = textField.text ?? ""
//            }
            
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                    if let currentValue = textField.text as NSString? {
                        let proposedValue = currentValue.replacingCharacters(in: range, with: string)
                        self.text.wrappedValue = proposedValue
                    }
                    return true
                }
        }
    
    
    
    public func makeUIView(context: Context) -> CntrTextField {
        let textfield = CntrUI.TextfieldWithoutBorder(frame: .zero, inActiveborderColor: .gray, activeBorderColor: .appAccent, selectedTextColor: textColor)
        textfield.textColor = textColor
        textfield.isSecureTextEntry = isSecureTextField
        textfield.placeholder = placeholder
        textfield.keyboardType = keyboardType
        textfield.delegate = context.coordinator
        textfield.autocapitalizationType = .none
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.textAlignment = textAlignment
        return textfield
    }
    
    public func updateUIView(_ uiView: CntrTextField, context: Context)
    {
        uiView.text = text.wrappedValue
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
                    uiView.becomeFirstResponder()
                    context.coordinator.didBecomeFirstResponder = true
                }
        
    }

}


public struct TextfieldWithBorder : UIViewRepresentable {

    public var text: Binding<String>
    public var placeholder: String
    public var keyboardType: UIKeyboardType
    public var textColor: UIColor
    public var isFirstResponder: Bool = false
    public var isSecureTextField: Bool
    public var textAlignment: NSTextAlignment
    
        
    public init(text: Binding<String>, placeholder: String, keyboardType: UIKeyboardType = .default, isFirstResponder: Bool = false, isSecureTextField: Bool = false, textAlignment: NSTextAlignment = .left, textColor: UIColor = .black) {
        
        self.placeholder = placeholder
        self.textColor = textColor
        self.keyboardType = keyboardType
        self.isFirstResponder = isFirstResponder
        self.isSecureTextField = isSecureTextField
        self.textAlignment = textAlignment
        self.text = text
    }
    
    
    public func makeCoordinator() -> Coordinator
    {
        return Coordinator(text)
    }

    public class Coordinator: NSObject, UITextFieldDelegate {
            var text: Binding<String>
            var didBecomeFirstResponder = false

        public init(_ text: Binding<String>) {
                    self.text = text
                }
            
//            func textFieldDidEndEditing(_ textField: UITextField) {
//                self.text.wrappedValue = textField.text ?? " "
//            }
            
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                    if let currentValue = textField.text as NSString? {
                        let proposedValue = currentValue.replacingCharacters(in: range, with: string)
                        self.text.wrappedValue = proposedValue
                    }
                    return true
                }
            

        }
    
    public func makeUIView(context: Context) -> CntrTextField {
        let textfield = CntrUI.TextfieldWithBorder(frame: .zero, withBorderColor: .appAccent, withBorderWidth: 2, withCornerRadius: 2)
        textfield.textColor = textColor
        textfield.labelColor = textColor
        textfield.placeholder = placeholder
        textfield.isSecureTextEntry = isSecureTextField
        textfield.keyboardType = keyboardType
        textfield.delegate = context.coordinator
        textfield.autocapitalizationType = .none
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.textAlignment = textAlignment
        return textfield
    }
    
    public func updateUIView(_ uiView: CntrTextField, context: Context)
    {
        uiView.text = text.wrappedValue
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
                    uiView.becomeFirstResponder()
                    context.coordinator.didBecomeFirstResponder = true
                }
    }

}

public struct SecureTextfieldWithoutBorder : UIViewRepresentable {

    public var text: Binding<String>
    public var placeholder: String
    public var textColor: UIColor
    public var keyboardType: UIKeyboardType
    public var isFirstResponder: Bool = false
    public var textAlignment: NSTextAlignment
        
    public init(text: Binding<String>, placeholder: String, keyboardType: UIKeyboardType = .default, isFirstResponder: Bool = false, textAlignment: NSTextAlignment = .left, textColor: UIColor = .black) {
        
        self.placeholder = placeholder
        self.textColor = textColor
        self.keyboardType = keyboardType
        self.isFirstResponder = isFirstResponder
        self.textAlignment = textAlignment
        self.text = text
    }
    
    
    public func makeCoordinator() -> Coordinator
    {
        return Coordinator(text)
    }

    public class Coordinator: NSObject, UITextFieldDelegate {
            var text: Binding<String>
            var didBecomeFirstResponder = false

        public init(_ text: Binding<String>) {
                    self.text = text
                }
            
//            func textFieldDidEndEditing(_ textField: UITextField) {
//                self.text.wrappedValue = textField.text ?? " "
//            }
            
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                    if let currentValue = textField.text as NSString? {
                        let proposedValue = currentValue.replacingCharacters(in: range, with: string)
                        self.text.wrappedValue = proposedValue
                    }
                    return true
                }
            

        }
    
    public func makeUIView(context: Context) -> CntrTextField {
        let textfield = CntrUI.TextfieldWithoutBorder(frame: .zero, inActiveborderColor: .gray, activeBorderColor: .appAccent, selectedTextColor: textColor)
        textfield.textColor = textColor
        textfield.labelColor = textColor
        textfield.placeholder = placeholder
        textfield.isSecureTextEntry = true
        textfield.autocorrectionType = .no
        textfield.textContentType = .none
        textfield.keyboardType = keyboardType
        textfield.delegate = context.coordinator
        textfield.textAlignment = textAlignment
        textfield.autocapitalizationType = .none
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }
    
    public func updateUIView(_ uiView: CntrTextField, context: Context)
    {
        uiView.text = text.wrappedValue
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
                    uiView.becomeFirstResponder()
                    context.coordinator.didBecomeFirstResponder = true
                }
    }

}


public struct SecureTextfieldWithBorder : UIViewRepresentable {

    public var text: Binding<String>
    public var placeholder: String
    public var textColor: UIColor
    public var keyboardType: UIKeyboardType
    public var isFirstResponder: Bool = false
    public var textAlignment: NSTextAlignment
        
    public init(text: Binding<String>, placeholder: String, keyboardType: UIKeyboardType = .default, isFirstResponder: Bool = false, textAlignment: NSTextAlignment = .left, textColor: UIColor = .black) {
        
        self.placeholder = placeholder
        self.textColor = textColor
        self.keyboardType = keyboardType
        self.isFirstResponder = isFirstResponder
        self.textAlignment = textAlignment
        self.text = text
    }
    
    
    public func makeCoordinator() -> Coordinator
    {
        return Coordinator(text)
    }

    public class Coordinator: NSObject, UITextFieldDelegate {
            var text: Binding<String>
            var didBecomeFirstResponder = false

        public init(_ text: Binding<String>) {
                    self.text = text
                }
            
//            func textFieldDidEndEditing(_ textField: UITextField) {
//                self.text.wrappedValue = textField.text ?? " "
//            }
            
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                    if let currentValue = textField.text as NSString? {
                        let proposedValue = currentValue.replacingCharacters(in: range, with: string)
                        self.text.wrappedValue = proposedValue
                    }
                    return true
                }
            

        }
    
    public func makeUIView(context: Context) -> CntrTextField {
        
        let textfield = CntrUI.TextfieldWithBorder(frame: .zero, withBorderColor: .appAccent, withBorderWidth: 2, withCornerRadius: 2)
        textfield.textColor = textColor
        textfield.isSecureTextEntry = true
        textfield.placeholder = placeholder
        textfield.keyboardType = keyboardType
        textfield.textAlignment = textAlignment
        textfield.autocorrectionType = .no
        textfield.textContentType = .none
        textfield.delegate = context.coordinator
        textfield.autocapitalizationType = .none
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }
    
    public func updateUIView(_ uiView: CntrTextField, context: Context)
    {
        
        uiView.text = text.wrappedValue
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
                    uiView.becomeFirstResponder()
                    context.coordinator.didBecomeFirstResponder = true
                }
    }

}

extension UIColor {
    
    static let darkBackgroundColor = UIColor(hex: "#121212") ?? .blue
    static let darkModalColor = UIColor(hex: "#272725") ?? .blue
    static let appAccent = UIColor(hex: "#2967FF") ?? .blue
    static let popupColor = UIColor(hex: "#2C3756") ?? .blue
    
    
}


extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
