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


extension UINavigationController: UIGestureRecognizerDelegate {
     override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        self.setNeedsStatusBarAppearanceUpdate()
        
//        let standardAppearance = UINavigationBarAppearance()
//        standardAppearance.backgroundColor = .white
//
//        let compactAppearance = UINavigationBarAppearance()
//        compactAppearance.backgroundColor = .green
//
//        let scrollEdgeAppearance = UINavigationBarAppearance()
//        scrollEdgeAppearance.backgroundColor = .white
//
//        navigationBar.standardAppearance = standardAppearance
//        navigationBar.compactAppearance = compactAppearance
//        navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
    }
     override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
public struct NavigationBarModifier: ViewModifier {
        
    public var backgroundColor: UIColor?
    public var titleColor: UIColor?

    public init(backgroundColor: UIColor?, titleColor: UIColor?) {
            self.backgroundColor = backgroundColor
            let coloredAppearance = UINavigationBarAppearance()
            coloredAppearance.configureWithTransparentBackground()
            coloredAppearance.backgroundColor = backgroundColor
            coloredAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .white]
            coloredAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .white]

            UINavigationBar.appearance().standardAppearance = coloredAppearance
            UINavigationBar.appearance().compactAppearance = coloredAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        }

    public func body(content: Content) -> some View {
            ZStack{
                content
                VStack {
                    GeometryReader { geometry in
                        Color(self.backgroundColor ?? .clear)
                            .frame(height: geometry.safeAreaInsets.top)
                            .edgesIgnoringSafeArea(.top)
                        Spacer()
                    }
                }
            }
        }
}
public extension View {
 
    public func navigationBarColor(backgroundColor: UIColor?, titleColor: UIColor?) -> some View {
            self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, titleColor: titleColor))
        }

}

public class NavBarCustomizer: ObservableObject {
    @Published public var backgroundColor: UIColor = .clear
    @Published public var height : CGFloat = 0
}

public struct NavBarBackgroundColor: EnvironmentKey {
    public static var defaultValue: UIColor = .clear
}

public extension EnvironmentValues {
    public var navbarBackgroundColor: UIColor {
        get { self[NavBarBackgroundColor.self] }
        set { self[NavBarBackgroundColor.self] = newValue }
    }
}

public struct NavigationConfigurator: UIViewControllerRepresentable {
    public var configure: (UINavigationController) -> Void = { _ in }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    public func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}
public struct NavBarAccessor: UIViewControllerRepresentable {
    public var callback: (UINavigationBar) -> Void
    public let proxyController = ViewController()

    public func makeUIViewController(context: UIViewControllerRepresentableContext<NavBarAccessor>) ->
                              UIViewController {
        proxyController.callback = callback
        return proxyController
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavBarAccessor>) {
    }

    public typealias UIViewControllerType = UIViewController

    public class ViewController: UIViewController {
        public var callback: (UINavigationBar) -> Void = { _ in }

        public override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let navBar = self.navigationController {
                self.callback(navBar.navigationBar)
            }
        }
    }
}
public struct BarBackButton: ViewModifier {
    @Environment(\.presentationMode) var presentation
    public func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: { presentation.wrappedValue.dismiss() }) {
              Image(systemName: "chevron.left")
                .foregroundColor(.black)
                .imageScale(.large)
            })
    }
}

public extension View {
    public func barBackButton() -> some View {
        self.modifier(BarBackButton())
    }
}

public extension UITabBarController {
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        print("here tab")
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBar.standardAppearance = appearance
    }
}


extension UITabBarController {
    override open func viewDidAppear(_ animated: Bool) {
        
        
        super.viewDidAppear(animated)
        print("here tab r")
        let standardAppearance = UITabBarAppearance()

        standardAppearance.configureWithOpaqueBackground()
        
        standardAppearance.configureWithTransparentBackground()

        tabBar.standardAppearance = standardAppearance
    }
}
