import SwiftUI
import Foundation
import Combine

public struct Modal<Content: View>: View {
    let content: Content
    var modalConfiguration: ModalConfiguration
    @State var showModal: Bool = true
    @State var opacity = 0.0
    @State private var contentHeight: CGFloat = 40
    @State private var fitInScreen = false
    let initialState: UIStatusBarStyle = UIApplication.statusBarStyle
    
    public init(modalConfiguration: ModalConfiguration, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.modalConfiguration = modalConfiguration
    }
    
    public var body: some View {
        if modalConfiguration.isPresenting.wrappedValue  {
            ZStack {
                VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        dismiss()
                    }
                
                VStack(spacing: 0) {
                    
                    
                    HStack {
                        Text(modalConfiguration.modalTitle)
                            .bold()
                            .font(.title)
                            .foregroundColor(modalConfiguration.titleColor)

                        Spacer()
                        modalButton

                    }
                    .padding()
                    
                    Divider()
                        .foregroundColor(Color.gray.opacity(0.2))
                        .frame(height: 1)
                    
                    GeometryReader { reader in
                        ScrollView(.vertical, showsIndicators: modalConfiguration.showScrollIndicator){
                            content
                                .frame(maxWidth: .infinity)
                                .overlay(
                                    GeometryReader { geo in
                                        Color.clear.preference(key: HeightPreferenceKey.self, value: geo.size.height)
                                    }
                                )
                        }
                        
                        .onPreferenceChange(HeightPreferenceKey.self) {
                            
                            contentHeight = $0
                        }
                        
                        
                    }
                    .frame(maxHeight: contentHeight)
                    
                    
                   
                                        
                }
                .background(modalConfiguration.backgroundColor)
                .cornerRadius(30)
                .padding(.horizontal,30)
//                .onPreferenceChange(HeightPreferenceKey.self) {
//                    contentHeight = $0
//                }
            }
            
            .opacity(opacity)
            .onAppear(perform: {
                onAppear()
            })
            
        }
        
    }
    
    public var modalButton: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image(systemName: "xmark")
                .foregroundColor(modalConfiguration.exitButtonColor)
                .imageScale(.large)
              .padding(.all, 5)
        })
    }
    
    public  func onAppear() {
        withAnimation(.easeIn(duration: 0.3)) {
           opacity = 1.0
       }
    }
   
    public func dismiss() {
        withAnimation(.easeInOut(duration: 0.3)) {
               opacity = 0.0
           }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showModal = false
            self.modalConfiguration.isPresenting.wrappedValue = false
        
    }

   }
}

public struct ModalConfiguration {
    public var onDisappear: (() -> Void)? = nil
    public var isPresenting: Binding<Bool> = .constant(true)
    public var animationDuration: Double = 0.6
    public var duration: TimeInterval = 0
    public var isScrollable: Bool = false
    public var showScrollIndicator: Bool = false
    public var modalTitle: String = ""
    public var backgroundColor: Color = .white
    public var exitButtonColor: Color = .white
    public var titleColor: Color = .black
    
    public init (onDisappear: (() -> Void)? = nil, isPresenting: Binding<Bool> = .constant(true), animationDuration: Double = 0.6, duration: TimeInterval = 0, isScrollable: Bool = false, showScrollIndicator: Bool = false, modalTitle: String = "", backgroundColor: Color = .white, exitButtonColor: Color = .white, titleColor: Color = .white) {
        
        self.onDisappear = onDisappear ?? nil
        self.isPresenting = isPresenting
        self.animationDuration = animationDuration
        self.isScrollable = isScrollable
        self.showScrollIndicator = showScrollIndicator
        self.modalTitle = modalTitle
        self.backgroundColor = backgroundColor
        self.exitButtonColor = exitButtonColor
        self.titleColor = titleColor
    }
}

public extension View {
    
    func modal<Content : View>(modalConfiguration: ModalConfiguration, @ViewBuilder content: @escaping () -> Content) -> some View {
        return ZStack {
            self
            Modal(modalConfiguration: modalConfiguration, content: content)
        }
    }
}


public struct VisualEffectView: UIViewRepresentable {
    public var effect: UIVisualEffect?
    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    public func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}




struct HeightPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 40
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
