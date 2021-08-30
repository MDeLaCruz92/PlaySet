//
//  PlayingCardView.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 1/13/19.
//  Copyright © 2019 Michael De La Cruz. All rights reserved.
//

import UIKit

class PlayingCardView: UIView {
    
    private lazy var grid = Grid(layout: .dimensions(rowCount: gridDimension.0, columnCount: gridDimension.1), frame: bounds)
    
    private var gridIndex = 0 { didSet { updateLayoutAndDisplay() } }
    private var shapeCount = 1 { didSet { updateLayoutAndDisplay() } }
    
    private var gridCell: CGRect {
        guard let cell = grid[gridIndex] else { return CGRect.zero }
        return cell
    }
        
    var amountOfCells: Int = 12 { didSet { updateLayoutAndDisplay() } }    
    var attributes = [Attributes]()
    
    struct Attributes {
        var color: UIColor
        var shade: String
        var shape: String
        var amount: Int
    }
    
    private func createCardView() {
        let view = UIView()
        view.layer.borderWidth = 1.5
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
        grid = Grid(layout: .dimensions(rowCount: gridDimension.0, columnCount: gridDimension.1), frame: bounds)
        
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
    
    func drawCardAttributes() {
        for index in 0...amountOfCells - 1 {
            gridIndex = index

            colorPath()
                        
            for amount in 1...attributes[index].amount {
                shapeCount = amount

                let path = UIBezierPath()
                let context = UIGraphicsGetCurrentContext()
                context?.saveGState()
                
                drawShapes(with: path)
                drawShade(with: path)
                            
                path.lineWidth = Shape.lineWidth
                path.stroke()
                context?.restoreGState()
            }
        }
    }
}

// MARK: - Shapes

extension PlayingCardView {
    struct Shape {
        static let circle = "circle"
        static let square = "square"
        static let triangle = "triangle"
        
        static let lineWidth: CGFloat = 1.5
        static let lineStripe: CGFloat = 3.5
        
        static let startAngle: CGFloat = 0.0
        static let endAngle: CGFloat = 2 * CGFloat.pi
    }
    
    private var arcLine: CGPoint {
        return CGPoint(x: gridCell.midX + strokeDistance * cos(Shape.startAngle),
                       y: gridCell.midY + strokeDistance * sin(Shape.startAngle))
    }
    
    private var shapeOffSetX: CGFloat {
        let offsetX = grid.cellSize.height < grid.cellSize.width ? strokeDistance * 2 : 0.0
        switch shapeCount {
        case 2: return offsetX
        case 3: return -offsetX
        default: return 0.0
        }
    }
    
    private var shapeOffSetY: CGFloat {
        let offsetY = grid.cellSize.height < grid.cellSize.width ? 0.0 : strokeDistance * 2
        switch shapeCount {
        case 2: return offsetY
        case 3: return -offsetY
        default: return 0.0
        }
    }
        
    private var strokeDistance: CGFloat {
        switch attributes[gridIndex].amount {
        case 1: return grid.cellSize.height > grid.cellSize.width ? (grid.cellSize.width / 3) : grid.cellSize.height / 3
        case 2: return grid.cellSize.height > grid.cellSize.width ? (grid.cellSize.width / 5) : grid.cellSize.height / 5
        case 3: return grid.cellSize.height > grid.cellSize.width ? (grid.cellSize.width / 6) : grid.cellSize.height / 6
        default: return grid.cellSize.height > grid.cellSize.width ? (grid.cellSize.width / 6) : grid.cellSize.height / 6
        }
    }
    
    private func drawShapes(with path: UIBezierPath) {
        switch attributes[gridIndex].shape {
        case Shape.circle:
            path.move(to: arcLine.offsetBy(dx: shapeOffSetX, dy: shapeOffSetY))
            path.addArc(
                withCenter: CGPoint(x: gridCell.midX, y: gridCell.midY).offsetBy(dx: shapeOffSetX, dy: shapeOffSetY),
                radius: strokeDistance,
                startAngle: Shape.startAngle,
                endAngle: Shape.endAngle,
                clockwise: true
            )
        case Shape.square:
            path.move(to: CGPoint(x: gridCell.midX - strokeDistance, y: gridCell.midY - strokeDistance).offsetBy(dx: shapeOffSetX, dy: shapeOffSetY))
            path.addLine(to: CGPoint(x: gridCell.midX + strokeDistance, y: gridCell.midY - strokeDistance).offsetBy(dx: shapeOffSetX, dy: shapeOffSetY))
            path.addLine(to: CGPoint(x: gridCell.midX + strokeDistance, y: gridCell.midY + strokeDistance).offsetBy(dx: shapeOffSetX, dy: shapeOffSetY))
            path.addLine(to: CGPoint(x: gridCell.midX - strokeDistance, y: gridCell.midY + strokeDistance).offsetBy(dx: shapeOffSetX, dy: shapeOffSetY))
            path.close()
        case Shape.triangle:
            path.move(to: CGPoint(x: gridCell.midX, y: gridCell.midY - strokeDistance).offsetBy(dx: shapeOffSetX, dy: shapeOffSetY))
            path.addLine(to: CGPoint(x: gridCell.midX + strokeDistance, y: gridCell.midY + strokeDistance / 2).offsetBy(dx: shapeOffSetX, dy: shapeOffSetY))
            path.addLine(to: CGPoint(x: gridCell.midX - strokeDistance, y: gridCell.midY + strokeDistance / 2).offsetBy(dx: shapeOffSetX, dy: shapeOffSetY))
            path.close()
        default: return
        }
    }
}

// MARK: - Color and Striping

extension PlayingCardView {
    func drawStripes(with path: UIBezierPath) {
        path.addClip()
            
        let stripes = stride(from: gridCell.minX, to: gridCell.maxX, by: Shape.lineStripe)
        
        for pointX in stripes {
            path.move(to: CGPoint(x: pointX, y: gridCell.minY).offsetBy(dx: shapeOffSetX, dy: shapeOffSetY))
            path.addLine(to: CGPoint(x: pointX, y: gridCell.maxY).offsetBy(dx: shapeOffSetX, dy: shapeOffSetY))
        }
    }
    
    func colorPath() {
        if (attributes[gridIndex].shade ==  "filled") {
            UIColor.purple.setStroke()
        } else {
            attributes[gridIndex].color.setStroke()
        }
        attributes[gridIndex].color.setFill()
    }
    
    func drawShade(with path: UIBezierPath) {
        switch attributes[gridIndex].shade {
        case "filled": path.fill()
        case "striped": drawStripes(with: path)
        default: return
        }
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
    
    func createGridLayout(amount: Int) {
        for _ in 0...amount - 1 {
            createCardView()
        }
    }
}

// MARK: - Core Graphics

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint  {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
