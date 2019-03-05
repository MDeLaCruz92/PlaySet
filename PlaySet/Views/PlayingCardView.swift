//
//  PlayingCardView.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 1/13/19.
//  Copyright © 2019 Michael De La Cruz. All rights reserved.
//

import UIKit

class PlayingCardView: UIView {
    
    var shape: String = "▲" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var color: String = "red"  { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var amount: Int = 1 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var shading: String = "shading" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    private var cardFeatureString: NSAttributedString {
        return centeredAttributedString(featureString, fontSize: cornerFontSize)
    }
    
    private lazy var upperLeftCornerButton = createCardButton()
    
    // MARK: Override methods
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill()
        roundedRect.fill()
        
        let grid = Grid(layout: .dimensions(rowCount: 6, columnCount: 6), frame: roundedRect.bounds)
//        cardFeatureString.draw(in: bounds.zoom(by: SizeRatio.faceCardImageSizeToBoundsSize))
        drawCircle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureCardButton(upperLeftCornerButton)
        upperLeftCornerButton.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
    }
    
    // MARK: Private methods
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle, .font: font])
    }

    private func createCardButton() -> UIButton  {
        let button = UIButton()
       addSubview(button)
        return button
    }
    
    private func configureCardButton(_ button: UIButton) {
        button.setAttributedTitle(cardFeatureString, for: .normal)
        button.frame.size = CGSize.zero
        button.sizeToFit()
    }
    
    private func drawCircle() {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        path.lineWidth = 5.0
        path.stroke()
        path.fill()
    }
}

//MARK: Extensions
extension PlayingCardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    private var featureString: String {
        switch amount {
        case 1: return "\(shape)"
        case 2: return " \(shape) \(shape)"
        case 3: return " \(shape) \(shape) \(shape)"
        default: return "?"
        }
    }
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint  {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

