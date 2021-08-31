//
//  File.swift
//  
//
//  Created by Samuel Tsokwa on 2021-08-31.
//

import Foundation
import SwiftUI

public struct Toast<Content : View> : View {
    
    let content: Content
    var toastConfiguration: ToastConfiguration
    @State var opacity = 0.0
    @State var timer: Timer? = nil
    
    public init(toastConfiguration: ToastConfiguration, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.toastConfiguration = toastConfiguration
        if toastConfiguration.onToastTap == nil {
            self.toastConfiguration.onToastTap = dismiss
        }
    }
    
    public var body: some View {
        if toastConfiguration.isPresenting.wrappedValue {
            
            ZStack {
                VStack {
                    Spacer()
                    ZStack {

                        content
                            .padding(.all, 9)
                            
                    }
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    .frame(width: UIScreen.main.bounds.width - 20, alignment: .center)
                    .background(toastConfiguration.toastBackgroundColor)
                    .cornerRadius(4)
                    .shadow(color: Color.gray.opacity(0.5), radius: 6)
                    .onTapGesture {
                        guard let onToastTap = toastConfiguration.onToastTap else {return}
                        onToastTap()
                    }
                    .onDisappear(perform: {
                        onDisAppear()
                    })
                    .onAppear(perform: {
                        onAppear()
                    })
                }
                
            }
            .opacity(opacity)
            
            
        }
    }
    
    public func onAppear() {
        withAnimation(.easeIn(duration: toastConfiguration.animationDuration)) {
            opacity = 1.0
        }
        if toastConfiguration.duration > 0 {
            timer = Timer.scheduledTimer(withTimeInterval: toastConfiguration.duration, repeats: false) { _ in
                dismiss()
            }
        }
    }
    
    public func dismiss() {
        withAnimation(.easeInOut(duration: toastConfiguration.animationDuration - 0.2)) {
            opacity = 0.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + toastConfiguration.animationDuration - 0.2) {
            toastConfiguration.isPresenting.wrappedValue = false
        }
    }
    
    public func onDisAppear() {
        timer?.invalidate()
        timer = nil
        guard let onDisappear = toastConfiguration.onDisappear else {return}
        onDisappear()
    }
}

public struct ToastConfiguration {
    public var toastBackgroundColor: Color = .white
    public var onToastTap: (() -> Void)? = nil
    public var onDisappear: (() -> Void)? = nil
    public var isPresenting: Binding<Bool> = .constant(true)
    public var animationDuration: Double = 0.6
    public var duration: TimeInterval = 0
    public var isGlobal: Bool = false
    
    public init (toastBackgroundColor: Color = .white, onToastTap: (() -> Void)? = nil, onDisappear: (() -> Void)? = nil, isPresenting: Binding<Bool> = .constant(true), animationDuration: Double = 0.6, duration: TimeInterval = 0, isGlobal: Bool = false) {
        
        self.toastBackgroundColor = toastBackgroundColor
        self.onToastTap = onToastTap ?? nil
        self.onDisappear = onDisappear ?? nil
        self.isPresenting = isPresenting
        self.animationDuration = animationDuration
        self.duration = duration
        self.isGlobal = isGlobal
    }
}


public extension View {
    public func toast<Content : View>(toastConfiguration: ToastConfiguration, @ViewBuilder content: () -> Content) -> some View {
        return ZStack {
            self
            Toast(toastConfiguration: toastConfiguration, content: content)
        }
            
    }
}

