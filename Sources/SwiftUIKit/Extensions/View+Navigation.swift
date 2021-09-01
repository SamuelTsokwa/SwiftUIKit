//
//  View+Navigation.swift

//
//  Created by Samuel Tsokwa on 2021-04-07.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
public extension View {

    func onNavigation(_ action: @escaping () -> Void) -> some View {
        let isActive = Binding(
            get: { false },
            set: { newValue in
                if newValue {
                    action()
                }
            }
        )
        return NavigationLink(
            destination: EmptyView(),
            isActive: isActive
        ) {
            self
        }
    }

    func navigation<Item, Destination: View>(
        item: Binding<Item?>,
        @ViewBuilder destination: (Item) -> Destination
    ) -> some View {
        let isActive = Binding(
            get: { item.wrappedValue != nil },
            set: { value in
                if !value {
                    item.wrappedValue = nil
                }
            }
        )
        return navigation(isActive: isActive) {
            item.wrappedValue.map(destination)
        }
    }

    func navigation<Destination: View>(
        isActive: Binding<Bool>,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        overlay(
            NavigationLink(
                destination: isActive.wrappedValue ? destination() : nil,
                isActive: isActive,
                label: { EmptyView() }
            )
        )
    }
    
    //Modifier for full screen navigation
    func fullScreen<Item, Destination>(
        item: Binding<Item?>,
        @ViewBuilder destination: @escaping (Item) -> Destination
      ) -> some View where Destination: View, Item: Identifiable {
        _ = Binding(
          get: {
            item.wrappedValue != nil
          },
          set: { value in
            if !value {
                item.wrappedValue = nil
            }
          }
        )
        return background(EmptyView().fullScreenCover(item: item, content: destination))
      }
    
//    func fullScreen<Content: View>(isPresented: Binding<Bool>, shouldTriggerLoadingView: Binding<Bool> = .constant(false), @ViewBuilder content: @escaping() -> Content) -> some View {
//        
//        return background(EmptyView().fullScreenCover(isPresented: isPresented, content: {
//            FullscreenHelperView(dismiss: isPresented, content: content)
//                .loadingView(isShowing: shouldTriggerLoadingView)
//        }))
//    }
    
    func fullScreen<Content, Item>(item: Binding<Item?>, @ViewBuilder content: @escaping() -> Content)  -> some View where Content: View, Item: Identifiable {
        let isActive = Binding(
            get: { item.wrappedValue != nil },
            set: { value in
                if !value {
                    item.wrappedValue = nil
                }
            }
        )
        
        return background(EmptyView().fullScreenCover(isPresented: isActive, content: {
            FullscreenHelperView(dismiss: isActive, content: content)
        }))
    }
    
}

public extension NavigationLink {

    init<T: Identifiable, D: View>(item: Binding<T?>,
                                   @ViewBuilder destination: (T) -> D,
                                   @ViewBuilder label: () -> Label) where Destination == D? {
        let isActive = Binding(
            get: { item.wrappedValue != nil },
            set: { value in
                if !value {
                    item.wrappedValue = nil
                }
            }
        )
        self.init(
            destination: item.wrappedValue.map(destination),
            isActive: isActive,
            label: label
        )
    }

}

public struct FullscreenHelperView<Content: View>: View {
    
    let content: Content
    var dismiss: Binding<Bool>
    
    public init(dismiss: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.dismiss = dismiss
//        UIScrollView.appearance().keyboardDismissMode = .onDrag
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                modalButton
                    .edgesIgnoringSafeArea(.all)
                Spacer()
            }
            .padding(.top, 70)
            .padding(.leading, 20)
            .background(Color.white)
            ScrollView {
                VStack {
                    content
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                        .edgesIgnoringSafeArea(.all)
                        
                }
                .background(Color.white)
            }
            
            .edgesIgnoringSafeArea(.all)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
        .resignKeyboardOnDragGesture()
    }
    
    var modalButton: some View {
        Button(action: {
            dismiss.wrappedValue = false
        }, label: {
            Image(systemName: "xmark")
              .foregroundColor(.black)
                .imageScale(.large)
              .padding(.all, 5)
        })
    }
}
