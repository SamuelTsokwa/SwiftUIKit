//
//  File.swift
//  
//
//  Created by Samuel Tsokwa on 2021-08-31.
//

import Foundation
import Combine
import SwiftUI


public struct OutlinedButtonStyle: SwiftUI.ButtonStyle {
     
    public var color: Color
    public var borderColor: Color
    public var cornerRadius: CGFloat
    public init(color: Color = .clear, borderColor: Color, cornerRadius: CGFloat = 2) {
        self.color = color
        self.borderColor = borderColor
        self.cornerRadius = cornerRadius
    }
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(color)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .border(borderColor, width: 2)
            .cornerRadius(cornerRadius)
        
    }
}

public struct FilledButtonStyle: SwiftUI.ButtonStyle {
     
    public var color: Color
    public var cornerRadius: CGFloat
    public var padding: CGFloat
    public init(color: Color, cornerRadius: CGFloat = 2, padding: CGFloat = 10) {
        self.color = color
        self.cornerRadius = cornerRadius
        self.padding = padding
    }
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .padding(padding)
            .foregroundColor(.white)
            .background(color)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .cornerRadius(cornerRadius)
        
    }
}


public struct GradientBackgroundStyle: SwiftUI.ButtonStyle {
 
    public var startColor: Color
    public var endColor: Color
    
    public init(startColor: Color,endColor: Color) {
        self.startColor = startColor
        self.endColor = endColor
    }
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .leading, endPoint: .trailing).opacity(configuration.isPressed ? 0.5 : 1))
            .cornerRadius(25)
            .shadow(radius: 10)
    }
}
