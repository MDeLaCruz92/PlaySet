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
    var amountOfShapes: Int = 3 { didSet { updateLayoutAndDisplay() } }
    
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
//            drawCircle(gridCell: gridCell)
            
            let path = UIBezierPath()
            drawSquare(with: path, gridCell: gridCell)
//            drawTriangle(path: path, gridCell: gridCell)
            
            path.fill()
            path.stroke()
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
    
    var circleRadius: CGFloat {
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
            radius: circleRadius,
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
                radius: circleRadius,
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
                radius: circleRadius,
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
    
    private struct Triangle {
        static let linePoint: CGFloat = 10
        static let lineWidth: CGFloat = 2.5
        static let offSet: CGFloat = 20.0
    }
    
    private var triangleLine: CGFloat {
        switch amountOfShapes {
        case 1: return 10.0
        case 2: return 8.5
        case 3: return 7.0
        default: return 7.0
        }
    }
    
    private var triangleOffset: CGFloat {
        switch amountOfShapes {
        case 1: return 0.0
        case 2: return 19.0
        case 3: return 17.0
        default: return 19.0
        }
    }
    
    private func drawTriangle(path: UIBezierPath, gridCell: CGRect) {
        path.move(to: CGPoint(x: gridCell.midX, y: gridCell.midY - triangleLine))
        path.addLine(to: CGPoint(x: gridCell.midX, y: gridCell.midY - triangleLine))
        path.addLine(to: CGPoint(x: gridCell.midX + triangleLine, y: gridCell.midY))
        path.addLine(to: CGPoint(x: gridCell.midX - triangleLine, y: gridCell.midY))
        path.close()
        
        let offSetX = gridCell.height < gridCell.width ? triangleOffset : 0.0
        let offSetY = gridCell.height < gridCell.width ? 0.0 : triangleOffset
    
        if amountOfShapes >= 2 {
            path.move(to: CGPoint(x: gridCell.midX, y: gridCell.midY - triangleLine).offsetBy(dx: offSetX, dy: offSetY))
            path.addLine(to: CGPoint(x: gridCell.midX, y: gridCell.midY - triangleLine).offsetBy(dx: offSetX, dy: offSetY))
            path.addLine(to: CGPoint(x: gridCell.midX + triangleLine, y: gridCell.midY).offsetBy(dx: offSetX, dy: offSetY))
            path.addLine(to: CGPoint(x: gridCell.midX - triangleLine, y: gridCell.midY).offsetBy(dx: offSetX, dy: offSetY))
            path.close()
        }
        
        if amountOfShapes == 3 {
            path.move(to: CGPoint(x: gridCell.midX, y: gridCell.midY - triangleLine).offsetBy(dx: -offSetX, dy: -offSetY))
            path.addLine(to: CGPoint(x: gridCell.midX, y: gridCell.midY - triangleLine).offsetBy(dx: -offSetX, dy: -offSetY))
            path.addLine(to: CGPoint(x: gridCell.midX + triangleLine, y: gridCell.midY).offsetBy(dx: -offSetX, dy: -offSetY))
            path.addLine(to: CGPoint(x: gridCell.midX - triangleLine, y: gridCell.midY).offsetBy(dx: -offSetX, dy: -offSetY))
            path.close()
        }
        
        path.lineWidth = Triangle.lineWidth
    }
    
    func stripedTriangle(path: UIBezierPath) {
        path.move(to: CGPoint(x: 30, y: 20))
        path.addLine(to: CGPoint(x: 50, y: 20))
        path.addClip()
    }
}

// MARK: - Square

extension PlayingCardView {
    private struct Square {
        static let line: CGFloat = 5.0
        static let lineWidth: CGFloat = 3.0
        static let offSet: CGFloat = 17.0
    }
    
    var squareLine: CGFloat {
        switch amountOfShapes {
        case 1: return grid.cellSize.height > grid.cellSize.width ? (grid.cellSize.width / 3) : grid.cellSize.height / 3
        case 2: return grid.cellSize.height > grid.cellSize.width ? (grid.cellSize.width / 5) : grid.cellSize.height / 5
        case 3: return grid.cellSize.height > grid.cellSize.width ? (grid.cellSize.width / 6) : grid.cellSize.height / 6
        default: return grid.cellSize.height > grid.cellSize.width ? (grid.cellSize.width / 6) : grid.cellSize.height / 6
        }
    }
    
    func drawSquare(with path: UIBezierPath, gridCell: CGRect) {
        path.move(to: CGPoint(x: gridCell.midX - squareLine, y: gridCell.midY - squareLine))
        path.addLine(to: CGPoint(x: gridCell.midX + squareLine, y: gridCell.midY - squareLine))
        path.addLine(to: CGPoint(x: gridCell.midX + squareLine, y: gridCell.midY + squareLine))
        path.addLine(to: CGPoint(x: gridCell.midX - squareLine, y: gridCell.midY + squareLine))
        path.close()
        
        let offSetX = grid.cellSize.height < grid.cellSize.width ? (squareLine * 2) : 0.0
        let offSetY = grid.cellSize.height < grid.cellSize.width ? 0.0 : (squareLine * 2)
        
        if amountOfShapes >= 2 {
            path.move(to: CGPoint(x: gridCell.midX - squareLine, y: gridCell.midY - squareLine).offsetBy(dx: offSetX, dy: offSetY))
            path.addLine(to: CGPoint(x: gridCell.midX + squareLine, y: gridCell.midY - squareLine).offsetBy(dx: offSetX, dy: offSetY))
            path.addLine(to: CGPoint(x: gridCell.midX + squareLine, y: gridCell.midY + squareLine).offsetBy(dx: offSetX, dy: offSetY))
            path.addLine(to: CGPoint(x: gridCell.midX - squareLine, y: gridCell.midY + squareLine).offsetBy(dx: offSetX, dy: offSetY))
            path.close()
        }

        if amountOfShapes == 3 {
            path.move(to: CGPoint(x: gridCell.midX - squareLine, y: gridCell.midY - squareLine).offsetBy(dx: -offSetX, dy: -offSetY))
            path.addLine(to: CGPoint(x: gridCell.midX + squareLine, y: gridCell.midY - squareLine).offsetBy(dx: -offSetX, dy: -offSetY))
            path.addLine(to: CGPoint(x: gridCell.midX + squareLine, y: gridCell.midY + squareLine).offsetBy(dx: -offSetX, dy: -offSetY))
            path.addLine(to: CGPoint(x: gridCell.midX - squareLine, y: gridCell.midY + squareLine).offsetBy(dx: -offSetX, dy: -offSetY))
            path.close()
        }
        
        path.lineWidth = Square.lineWidth
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

