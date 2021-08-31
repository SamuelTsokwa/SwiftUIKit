//
//  File.swift
//  
//
//  Created by Samuel Tsokwa on 2021-08-31.
//

import Foundation
import UIKit


private extension TimeInterval {
    static let animation250ms: TimeInterval = 0.25
}

public extension UIColor {
    static let inactive: UIColor = .gray
}

private enum Constants {
    static let offset: CGFloat = 8
    static let placeholderSize: CGFloat = 16
}

public class CntrTextField: UITextField {

    // MARK: - Subviews
    private var border = UIView()
    private var label = UILabel()

    // MARK: - Private Properties
    private var scale: CGFloat {
        Constants.placeholderSize / fontSize
    }

    private var fontSize: CGFloat
    {
        font?.pointSize ?? 0
    }

    private var labelHeight: CGFloat
    {
        ceil(font?.withSize(Constants.placeholderSize).lineHeight ?? 0)
    }

    private var textHeight: CGFloat
    {
        ceil(font?.lineHeight ?? 0)
    }

    private var isEmpty: Bool
    {
        text?.isEmpty ?? true
    }

    private var textInsets: UIEdgeInsets
    {
        UIEdgeInsets(top: Constants.offset + labelHeight, left: 7, bottom: Constants.offset, right: 7)
    }

    // MARK: - Initialization
    init(frame: CGRect, inActiveborderColor : UIColor = .inactive, activeBorderColor : UIColor = .blue, isBordered :Bool = false, selectedTextColor: UIColor = .black)
    {
        self.withFillColor = activeBorderColor
        self.borderWidth = 0
        self.borderedColor = activeBorderColor
        self.isBordered = isBordered
        self.activeBorderColor = activeBorderColor
        self.inActiveborderColor = inActiveborderColor
        self.withCornerRadius = 0
        self.labelColor = selectedTextColor
        self.placeholderColor = .gray
        super.init(frame: frame)
        
        setupUIWithoutBorder()
    }
    
    init(frame: CGRect,withBorderColor: UIColor, withBorderWidth:CGFloat, withCornerRadius: CGFloat)
    {
        self.withFillColor = withBorderColor
        self.borderWidth = withBorderWidth
        self.borderedColor = withBorderColor
        self.isBordered = true
        self.activeBorderColor = withBorderColor
        self.inActiveborderColor = withBorderColor
        self.withCornerRadius = withCornerRadius
        self.labelColor = .black
        self.placeholderColor = .gray
        super.init(frame: frame)
        
        
        setupUIWithBorder()
    }
    
    init(frame: CGRect, withFillColor: UIColor, withBorderColor: UIColor = .blue,withBorderWidth:CGFloat = 2, withCornerRadius: CGFloat = 2)
    {
        self.withFillColor = withFillColor
        self.borderWidth = withBorderWidth
        self.borderedColor = withBorderColor
        self.isBordered = true
        self.activeBorderColor = withFillColor
        self.inActiveborderColor = withFillColor
        self.withCornerRadius = withCornerRadius
        self.labelColor = .black
        self.placeholderColor = .gray
        super.init(frame: frame)
        
        
        setupUIWithFill()
    }
    
    

    required init?(coder: NSCoder, inActiveborderColor : UIColor = .inactive, activeBorderColor : UIColor = .blue, isBordered :Bool = false)
    {
        self.withFillColor = activeBorderColor
        self.borderWidth = 0
        self.borderedColor = activeBorderColor
        self.isBordered = isBordered
        self.activeBorderColor = activeBorderColor
        self.inActiveborderColor = inActiveborderColor
        self.withCornerRadius = 0
        self.labelColor = .black
        self.placeholderColor = .gray
        
        super.init(coder: coder)
        setupUIWithoutBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITextField
    public override var intrinsicContentSize: CGSize
    {
        return CGSize(width: bounds.width, height: textInsets.top + textHeight + textInsets.bottom)
    }

    public override var placeholder: String? {
        didSet
        {
            label.text = placeholder
        }
    }
    
    public var placeholderColor: UIColor
    {
        didSet
        {
            attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : placeholderColor])
        }
    }
    
    public var inActiveborderColor: UIColor
    {
        didSet
        {
            border.backgroundColor = inActiveborderColor
        }
    }
    public var activeBorderColor: UIColor
    public var borderWidth: CGFloat
    public var borderedColor: UIColor
    public var withFillColor: UIColor
    public var withCornerRadius: CGFloat
    
    public var isBordered: Bool
    {
        didSet
        {
            border.isHidden = true
            borderStyle = .roundedRect
            layer.borderWidth = borderWidth
            layer.borderColor = borderedColor.cgColor
        }
    }
    public var labelColor: UIColor
    {
        didSet
        {
            label.textColor = labelColor
        }
    }
    

    public override func layoutSubviews() {
        super.layoutSubviews()
        border.frame = CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1)
        updateLabel(animated: false)
    }

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return .zero
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)

//        guard !isFirstResponder else {
//            return
//        }
        label.transform = .identity
        label.frame = bounds.inset(by: textInsets)
    }

    // MARK: - Private Methods
    private func setupUIWithoutBorder() {
        borderStyle = .none

        
        border.backgroundColor = inActiveborderColor
        border.isUserInteractionEnabled = false
        addSubview(border)

        label.textColor = self.labelColor
        label.font = font
        label.text = placeholder
        label.isUserInteractionEnabled = false
        addSubview(label)

        addTarget(self, action: #selector(handleEditing), for: .allEditingEvents)
    }
    private func setupUIWithFill() {
        

        backgroundColor = withFillColor
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 3)
        bottomLine.backgroundColor = borderedColor.cgColor
        self.borderStyle = .none
        self.layer.addSublayer(bottomLine)
        label.textColor = .black
        label.font = font
        label.text = placeholder
        label.isUserInteractionEnabled = false
        addSubview(label)

        addTarget(self, action: #selector(handleEditing), for: .allEditingEvents)
    }
    
    private func setupUIWithBorder() {
        

        
        border.isUserInteractionEnabled = false
        addSubview(border)
        backgroundColor = .clear
        border.isHidden = true
        borderStyle = .roundedRect
        layer.borderWidth = borderWidth
        layer.cornerRadius = withCornerRadius
        layer.borderColor = borderedColor.cgColor
        
        label.textColor = .black
        label.font = font
        label.text = placeholder
        label.isUserInteractionEnabled = false
        addSubview(label)

        addTarget(self, action: #selector(handleEditing), for: .allEditingEvents)
    }

    @objc
    private func handleEditing() {
        updateLabel()
        updateBorder()
    }

    private func updateBorder() {
        let borderColor = isFirstResponder ? activeBorderColor : inActiveborderColor
        UIView.animate(withDuration: .animation250ms) {
            self.border.backgroundColor = borderColor
        }
    }

    private func updateLabel(animated: Bool = true) {
        let isActive = isFirstResponder || !isEmpty

        let offsetX = -label.bounds.width * (1 - scale) / 2
        let offsetY = -label.bounds.height * (1 - scale) / 2

        let transform = CGAffineTransform(translationX: offsetX, y: offsetY - labelHeight - Constants.offset)
            .scaledBy(x: scale, y: scale)

        guard animated else {
            label.transform = isActive ? transform : .identity
            return
        }

        UIView.animate(withDuration: .animation250ms) {
            self.label.transform = isActive ? transform : .identity
        }
    }
}


public class CntrUI
{
    
    public static func TextfieldWithoutBorder(frame: CGRect, inActiveborderColor:UIColor, activeBorderColor:UIColor, selectedTextColor: UIColor) -> CntrTextField
    {
        return CntrTextField(frame: frame, inActiveborderColor: inActiveborderColor, activeBorderColor: activeBorderColor, selectedTextColor: selectedTextColor)
    }
    
    
    public static func TextfieldWithBorder(frame: CGRect, withBorderColor:UIColor, withBorderWidth:CGFloat, withCornerRadius:CGFloat) -> CntrTextField
    {
        return CntrTextField(frame: frame,withBorderColor: withBorderColor, withBorderWidth: withBorderWidth, withCornerRadius: withCornerRadius)
    }
    
    public static func TextfieldwithFillColor(frame: CGRect, withFillColor:UIColor, withCornerRadius:CGFloat, withBorderColor:UIColor, withBorderWidth:CGFloat) -> CntrTextField
    {
        return CntrTextField(frame: frame, withFillColor: withFillColor, withBorderColor: withBorderColor, withBorderWidth: withBorderWidth, withCornerRadius: withCornerRadius)
    }
    
//    public static func ButtonWithBorder(frame: CGRect, withBorderColor: UIColor, withborderWidth: CGFloat, withCornerRadius: CGFloat) -> CntrButton
//    {
//        return CntrButton(frame: frame, withBorderColor: withBorderColor, withborderWidth: withborderWidth, withCornerRadius: withCornerRadius)
//    }
//
//    public static func ButtonWithBorder(frame: CGRect, withBorderColor: UIColor) -> CntrButton
//    {
//        return CntrButton(frame: frame, withBorderColor: withBorderColor)
//    }
//
//    public static func ButtonWithFillColor(frame: CGRect, withFillColor: UIColor, withCornerRadius: CGFloat ) -> CntrButton
//    {
//        return CntrButton(frame: frame, withFillColor: withFillColor, withCornerRadius: withCornerRadius)
//    }
//
//    public static func ButtonWithFillColor(frame: CGRect, withFillColor: UIColor) -> CntrButton
//    {
//        return CntrButton(frame: frame, withFillColor: withFillColor)
//    }
}
