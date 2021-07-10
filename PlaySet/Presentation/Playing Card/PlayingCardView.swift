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
    
    private lazy var grid = Grid(layout: .dimensions(rowCount: gridDimension.0, columnCount: gridDimension.1), frame: bounds)
        
    var amountOfCells: Int = 12 { didSet { updateLayoutAndDisplay() } }
    var color: UIColor = .green { didSet { updateLayoutAndDisplay() } }
    var shade: String = "" { didSet { updateLayoutAndDisplay() } }
    var shape: String = "" { didSet { updateLayoutAndDisplay() } }
    var amountOfShapes: Int = 2 { didSet { updateLayoutAndDisplay() } }
    
    private func createCardView() {
        let view = UIView()
//        view.backgroundColor = .green
        view.layer.borderWidth = 3.0
        view.layer.borderColor = UIColor.black.cgColor
        addSubview(view)
    }
        
    override func draw(_ rect: CGRect) {
        #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).setFill()
        let roundedRect = UIBezierPath(rect: bounds)
        roundedRect.fill()
                
        drawCardAttributes()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grid.frame = bounds
        
        for index in 0...amountOfCells - 1 {
            if let gridCell = grid[index] {
                subviews[index].frame.size = gridCell.size
                subviews[index].frame.origin = gridCell.origin
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateLayoutAndDisplay()
    }
    
    func updateLayoutAndDisplay() {
        setNeedsDisplay(); setNeedsLayout()
    }
}

// MARK: - Grid

extension PlayingCardView {
    private var gridDimension: (Int, Int) {
        switch amountOfCells {
        case 1...12: return (4, 3)
        case 13...35: return (7, 5)
        case 36...50: return (10, 5)
        case 51...70: return (10, 7)
        default: return (9,9)
        }
    }
    
    func createGridLayout() {
        for _ in 0...amountOfCells - 1 {
            createCardView()
        }
    }
}

// MARK: - Drawing

extension PlayingCardView {
    func drawCardAttributes() {
        for index in 0...amountOfCells - 1 {
            guard let gridCell = grid[index] else { return }
            colorPath(color)
            drawCircle(gridCell: gridCell)
        }
    }
}

// MARK: - Circle

extension PlayingCardView {
    private struct Circle {
        static let startAngle: CGFloat = 0.0
        static let endAngle: CGFloat = 2 * CGFloat.pi
        static let lineWidth: CGFloat = 2.5
        static let offSet: CGFloat = 19.0
    }
    
    var radius: CGFloat {
        switch amountOfShapes {
        case 1: return 10.0
        case 2: return 8.5
        case 3: return 7.0
        default: return 7.0
        }
    }
    
    func drawCircle(gridCell: CGRect) {
        let offSetX = gridCell.height < gridCell.width ? Circle.offSet : 0.0
        let offSetY = gridCell.height < gridCell.width ? 0.0 : Circle.offSet
        
        let path = UIBezierPath()
        path.addArc(
            withCenter: CGPoint(x: gridCell.midX, y: gridCell.midY),
            radius: radius,
            startAngle: Circle.startAngle,
            endAngle: Circle.endAngle,
            clockwise: true
        )
        path.close()
        path.lineWidth = Circle.lineWidth
        path.fill()
        path.stroke()
                
        if amountOfShapes >= 2 {
            let newPath = UIBezierPath()
            newPath.addArc(
                withCenter: CGPoint(x: gridCell.midX, y: gridCell.midY)
                    .offsetBy(dx: offSetX, dy: offSetY),
                radius: radius,
                startAngle: Circle.startAngle,
                endAngle: Circle.endAngle,
                clockwise: true
            )
            newPath.close()
            newPath.lineWidth = Circle.lineWidth
            newPath.fill()
            newPath.stroke()
        }
        
        if amountOfShapes == 3 {
            let newPath = UIBezierPath()
            newPath.addArc(
                withCenter: CGPoint(x: gridCell.midX, y: gridCell.midY)
                    .offsetBy(dx: -offSetX, dy: -offSetY),
                radius: radius,
                startAngle: Circle.startAngle,
                endAngle: Circle.endAngle,
                clockwise: true
            )
            newPath.close()
            newPath.lineWidth = Circle.lineWidth
            newPath.fill()
            newPath.stroke()
        }
    }
}

// MARK: - Triangle

extension PlayingCardView {
    
    private func trianglePath(path: UIBezierPath, mid: CGPoint) {
        path.move(to: CGPoint(x: mid.x, y: mid.y - 10))
        path.addLine(to: CGPoint(x: mid.x, y: mid.y - 10))
        path.addLine(to: CGPoint(x: mid.x + 10, y: mid.y))
        path.addLine(to: CGPoint(x: mid.x - 10, y: mid.y))
        path.close()
        path.lineWidth = 2.5
    }
    
    private func drawTriangle(on view: UIView) {
        let path = UIBezierPath()
        let midPoint = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        path.move(to: midPoint)
        path.addLine(to: CGPoint(x: midPoint.x + 10, y: midPoint.y + 15))
        path.addLine(to: CGPoint(x: midPoint.x - 10, y: midPoint.y + 15))
        path.close()
        
        colorPath(.green)
                                
//        path.move(to: CGPoint(x: 40, y: 20).offsetBy(dx: 20, dy: 0))
//        path.addLine(to: CGPoint(x: 50, y: 60).offsetBy(dx: 20, dy: 0))
//        path.addLine(to: CGPoint(x: 30, y: 60).offsetBy(dx: 20, dy: 0))
//        path.close()
//
//        path.move(to: CGPoint(x: 40, y: 20).offsetBy(dx: -20, dy: 0))
//        path.addLine(to: CGPoint(x: 50, y: 60).offsetBy(dx: -20, dy: 0))
//        path.addLine(to: CGPoint(x: 30, y: 60).offsetBy(dx: -20, dy: 0))
//        path.close()
                
        path.lineWidth = LineWidth.triangle
        path.fill()
        path.stroke()
        
//        stripedTriangle(path: path)
    }
    
    func stripedTriangle(path: UIBezierPath) {
        path.move(to: CGPoint(x: 30, y: 20))
        path.addLine(to: CGPoint(x: 50, y: 20))
        path.addClip()
    }
}

// MARK: - Square

extension PlayingCardView {
    func squarePath(path: UIBezierPath, mid: CGPoint) {
//        guard shape == "square" else { return }
        
//        path.move(to: CGPoint(x: 80, y: 20))
//        path.addLine(to: CGPoint(x: 110, y: 20))
//        path.addLine(to: CGPoint(x: 110, y: 50))
//        path.addLine(to: CGPoint(x: 80, y: 50))
//        path.close()
        
        path.move(to: CGPoint(x: mid.x - Point.square, y: mid.y - Point.square))
        path.addLine(to: CGPoint(x: mid.x + Point.square, y: mid.y - Point.square))
        path.addLine(to: CGPoint(x: mid.x + Point.square, y: mid.y + Point.square))
        path.addLine(to: CGPoint(x: mid.x - Point.square, y: mid.y + Point.square))
        path.close()
        
        path.lineWidth = LineWidth.square
//        stripedSquare(path: path)
    }
    
    func stripedSquare(path: UIBezierPath, mid: CGPoint) {
        path.move(to: CGPoint(x: 100, y: 20))
        path.addLine(to: CGPoint(x: 100, y: 80))
        path.addClip()
        path.close()
        
        path.move(to: CGPoint(x: 90, y: 20))
        path.addLine(to: CGPoint(x: 90, y: 50))
        path.addClip()
        path.close()
        
        path.stroke()
    }
}

// MARK: - CardView Values

extension PlayingCardView {
    private struct Point {
        static let square: CGFloat = 5.0
        static let triangle: CGFloat = 10.0
        static let circleRadius: CGFloat = 10.0
    }
    
    private struct LineWidth {
        static let square: CGFloat = 3.0
        static let triangle: CGFloat = 2.5
        static let circle: CGFloat = 5.0
    }
    
    private struct SizeRatio {
        static let drawPathSizeToBoundsSize: CGFloat = 0.75
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
        UIColor.purple.setStroke()
    }
}

// MARK: - Core Graphics

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

