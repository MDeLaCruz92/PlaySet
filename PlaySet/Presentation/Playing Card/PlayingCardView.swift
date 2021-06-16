//
//  PlayingCardView.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 1/13/19.
//  Copyright © 2019 Michael De La Cruz. All rights reserved.
//

import UIKit

@IBDesignable
class PlayingCardView: UIView {
                    
    // MARK: Override methods
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).setFill()
        roundedRect.fill()
                
        circlePath()
        
        trianglePath()
        
        squarePath()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
}

// MARK: - Shapes Path

extension PlayingCardView {
    
    private func circlePath() {
        colorPath(.cyan)
        
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 20, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        path.lineWidth = 5.0
        path.stroke()
        path.fill()
    }
    
    private func trianglePath() {
        colorPath(.green)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 40, y: 20))
        path.addLine(to: CGPoint(x: 50, y: 60))
        path.addLine(to: CGPoint(x: 30, y: 60))
        path.close()
        
        path.lineWidth = 2.5
        path.fill()
        path.stroke()
    }
    
    func squarePath() {
        UIColor.orange.setFill()
        UIColor.red.setStroke()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 80, y: 20))
        path.addLine(to: CGPoint(x: 110, y: 20))
        path.addLine(to: CGPoint(x: 110, y: 50))
        path.addLine(to: CGPoint(x: 80, y: 50))
        path.close()
        
        path.lineWidth = 3.0
        stripedPath(path: path)
    }
}

// MARK: - Stroke and Fill

extension PlayingCardView {
    
    func filledPath(path: UIBezierPath) {
        path.fill()
        path.stroke()
    }
    
    func colorPath(_ color: UIColor) {
        color.setFill()
        UIColor.red.setStroke()
    }
    
    func stripedPath(path: UIBezierPath) { // TODO: Draw the stripes for the shape. Maybe this will have to find it's way inside the path somehow
        path.addClip()
        path.stroke()
    }
}

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

