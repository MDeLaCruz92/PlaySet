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
            
            let path = UIBezierPath()
            
            drawCircle(with: path, gridCell: gridCell)
//            drawSquare(with: path, gridCell: gridCell)
//            drawTriangle(path: path, gridCell: gridCell)
            
            path.lineWidth = Shape.lineWidth
            path.fill()
            path.stroke()
        }
    }
}

// MARK: - Circle

extension PlayingCardView {
    func drawCircle(with path: UIBezierPath, gridCell: CGRect) {
        let arcLine = CGPoint(x: gridCell.midX + shapeLine * cos(Shape.startAngle),
                                 y: gridCell.midY + shapeLine * sin(Shape.startAngle))
        
        path.move(to: arcLine)
        path.addArc(
            withCenter: CGPoint(x: gridCell.midX, y: gridCell.midY),
            radius: shapeLine,
            startAngle: Shape.startAngle,
            endAngle: Shape.endAngle,
            clockwise: true
        )
                
        if amountOfShapes >= 2 {
            path.move(to: arcLine.offsetBy(dx: shapeOffSetX, dy: shapeOffSetY))
            path.addArc(
                withCenter: CGPoint(x: gridCell.midX, y: gridCell.midY)
                    .offsetBy(dx: shapeOffSetX, dy: shapeOffSetY),
                radius: shapeLine,
                startAngle: Shape.startAngle,
                endAngle: Shape.endAngle,
                clockwise: true
            )
        }
        
        if amountOfShapes == 3 {
            path.move(to: arcLine.offsetBy(dx: -shapeOffSetX, dy: -shapeOffSetY))
            path.addArc(
                withCenter: CGPoint(x: gridCell.midX, y: gridCell.midY)
                    .offsetBy(dx: -shapeOffSetX, dy: -shapeOffSetY),
                radius: shapeLine,
                startAngle: Shape.startAngle,
                endAngle: Shape.endAngle,
                clockwise: true
            )
        }
    }
}

// MARK: - Triangle

extension PlayingCardView {
    
    private func drawTriangle(path: UIBezierPath, gridCell: CGRect) {
        path.move(to: CGPoint(x: gridCell.midX, y: gridCell.midY - shapeLine))
        path.addLine(to: CGPoint(x: gridCell.midX, y: gridCell.midY - shapeLine))
        path.addLine(to: CGPoint(x: gridCell.midX + shapeLine, y: gridCell.midY))
        path.addLine(to: CGPoint(x: gridCell.midX - shapeLine, y: gridCell.midY))
        path.close()
    
        if amountOfShapes >= 2 {
            path.move(to: CGPoint(x: gridCell.midX, y: gridCell.midY - shapeLine).offsetBy(dx: shapeOffSetX, dy: shapeOffSetY))
            path.addLine(to: CGPoint(x: gridCell.midX, y: gridCell.midY - shapeLine).offsetBy(dx: shapeOffSetX, dy: shapeOffSetY))
            path.addLine(to: CGPoint(x: gridCell.midX + shapeLine, y: gridCell.midY).offsetBy(dx: shapeOffSetX, dy: shapeOffSetY))
            path.addLine(to: CGPoint(x: gridCell.midX - shapeLine, y: gridCell.midY).offsetBy(dx: shapeOffSetX, dy: shapeOffSetY))
            path.close()
        }
        
        if amountOfShapes == 3 {
            path.move(to: CGPoint(x: gridCell.midX, y: gridCell.midY - shapeLine).offsetBy(dx: -shapeOffSetX, dy: -shapeOffSetY))
            path.addLine(to: CGPoint(x: gridCell.midX, y: gridCell.midY - shapeLine).offsetBy(dx: -shapeOffSetX, dy: -shapeOffSetY))
            path.addLine(to: CGPoint(x: gridCell.midX + shapeLine, y: gridCell.midY).offsetBy(dx: -shapeOffSetX, dy: -shapeOffSetY))
            path.addLine(to: CGPoint(x: gridCell.midX - shapeLine, y: gridCell.midY).offsetBy(dx: -shapeOffSetX, dy: -shapeOffSetY))
            path.close()
        }
    }
    
    func stripedTriangle(path: UIBezierPath) {
        path.move(to: CGPoint(x: 30, y: 20))
        path.addLine(to: CGPoint(x: 50, y: 20))
        path.addClip()
    }
}

// MARK: - Shape

extension PlayingCardView {
    private struct Shape {
        static let lineWidth: CGFloat = 3.0
        static let startAngle: CGFloat = 0.0
        static let endAngle: CGFloat = 2 * CGFloat.pi
    }
    
    private var shapeOffSetX: CGFloat {
        return grid.cellSize.height < grid.cellSize.width ? shapeLine * 2 : 0.0
    }
    
    private var shapeOffSetY: CGFloat {
        return grid.cellSize.height < grid.cellSize.width ? 0.0 : shapeLine * 2
    }
    
    private var shapeLine: CGFloat {
        switch amountOfShapes {
        case 1: return grid.cellSize.height > grid.cellSize.width ? (grid.cellSize.width / 3) : grid.cellSize.height / 3
        case 2: return grid.cellSize.height > grid.cellSize.width ? (grid.cellSize.width / 5) : grid.cellSize.height / 5
        case 3: return grid.cellSize.height > grid.cellSize.width ? (grid.cellSize.width / 6) : grid.cellSize.height / 6
        default: return grid.cellSize.height > grid.cellSize.width ? (grid.cellSize.width / 6) : grid.cellSize.height / 6
        }
    }
    
    func drawSquare(with path: UIBezierPath, gridCell: CGRect) {
        path.move(to: CGPoint(x: gridCell.midX - shapeLine, y: gridCell.midY - shapeLine))
        path.addLine(to: CGPoint(x: gridCell.midX + shapeLine, y: gridCell.midY - shapeLine))
        path.addLine(to: CGPoint(x: gridCell.midX + shapeLine, y: gridCell.midY + shapeLine))
        path.addLine(to: CGPoint(x: gridCell.midX - shapeLine, y: gridCell.midY + shapeLine))
        path.close()
        
        let offSetX = grid.cellSize.height < grid.cellSize.width ? (shapeLine * 2) : 0.0
        let offSetY = grid.cellSize.height < grid.cellSize.width ? 0.0 : (shapeLine * 2)
        
        if amountOfShapes >= 2 {
            path.move(to: CGPoint(x: gridCell.midX - shapeLine, y: gridCell.midY - shapeLine).offsetBy(dx: offSetX, dy: offSetY))
            path.addLine(to: CGPoint(x: gridCell.midX + shapeLine, y: gridCell.midY - shapeLine).offsetBy(dx: offSetX, dy: offSetY))
            path.addLine(to: CGPoint(x: gridCell.midX + shapeLine, y: gridCell.midY + shapeLine).offsetBy(dx: offSetX, dy: offSetY))
            path.addLine(to: CGPoint(x: gridCell.midX - shapeLine, y: gridCell.midY + shapeLine).offsetBy(dx: offSetX, dy: offSetY))
            path.close()
        }

        if amountOfShapes == 3 {
            path.move(to: CGPoint(x: gridCell.midX - shapeLine, y: gridCell.midY - shapeLine).offsetBy(dx: -offSetX, dy: -offSetY))
            path.addLine(to: CGPoint(x: gridCell.midX + shapeLine, y: gridCell.midY - shapeLine).offsetBy(dx: -offSetX, dy: -offSetY))
            path.addLine(to: CGPoint(x: gridCell.midX + shapeLine, y: gridCell.midY + shapeLine).offsetBy(dx: -offSetX, dy: -offSetY))
            path.addLine(to: CGPoint(x: gridCell.midX - shapeLine, y: gridCell.midY + shapeLine).offsetBy(dx: -offSetX, dy: -offSetY))
            path.close()
        }
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

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint  {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

