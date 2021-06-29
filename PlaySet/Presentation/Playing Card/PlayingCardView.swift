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
    
    private lazy var grid: Grid = Grid(layout: .fixedCellSize(gridCellSize), frame: bounds)
    
    private lazy var dimensionGrid = Grid(layout: .dimensions(rowCount: gridDimension.0, columnCount: gridDimension.1), frame: bounds)
        
    var amountOfCells: Int = 12 { didSet { updateLayoutAndDisplay() } }
    
    private func createCardView(grid: Grid, origin: CGPoint) {
        let view = UIView()
        view.frame.size = grid.cellSize
        view.frame.origin = origin
        view.backgroundColor = .green
        view.layer.borderWidth = 3.0
        view.layer.borderColor = UIColor.black.cgColor
//        print("view.bounds.origin: \(view.frame.origin)")
        addSubview(view)
    }
    
    // MARK: Override methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createGridLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        createGridLayout()
    }
    
    override func draw(_ rect: CGRect) {
        #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).setFill()
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        roundedRect.fill()
        
//        circlePath()
//        trianglePath()
//        squarePath()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dimensionGrid.frame = bounds
        
        
        for index in 0...amountOfCells - 1 {
            if let gridCell = dimensionGrid[index] {
                subviews[index].frame.size = gridCell.size
                subviews[index].frame.origin = gridCell.origin
                print("index: \(index), subViews[index]: \(subviews[index].frame.origin), gridCell: \(gridCell.origin)")
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
    private struct GridFixedCellSize {
        static let extraSmall: CGSize = CGSize(width: 45, height: 45)
        static let small: CGSize = CGSize(width: 50, height: 50)
        static let medium: CGSize = CGSize(width: 55, height: 55)
        static let large: CGSize = CGSize(width: 65, height: 65)
        static let extraLarge: CGSize = CGSize(width: 100, height: 100)
    }
    
    private var gridCellSize: CGSize {
        switch amountOfCells {
        case 1...12: return  GridFixedCellSize.extraLarge
        case 13...35: return GridFixedCellSize.large
        case 36...50: return GridFixedCellSize.medium
        case 51...65: return GridFixedCellSize.small
        case 66...81: return GridFixedCellSize.extraSmall
        default: return GridFixedCellSize.small
        }
    }
    
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
        for index in 0...amountOfCells - 1 {
            if let gridCell = dimensionGrid[index] {
//                print("index: \(index), grid's origin: \(gridCell.origin)")
                createCardView(grid: dimensionGrid, origin: gridCell.origin)
            }
        }
    }
}

// MARK: - Circle Drawing

extension PlayingCardView {
    private func circlePath() {
        colorPath(.cyan)
        
        let path = UIBezierPath()
//        path.addArc(withCenter: CGPoint(x: gridCardView.bounds.midX, y: gridCardView.bounds.midY), radius: 20, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        path.lineWidth = 5.0
        path.stroke()
        path.fill()
        path.close()
    }
}

// MARK: - Triangle Drawing

extension PlayingCardView {
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
        
        stripedTriangle(path: path)
    }
    
    func stripedTriangle(path: UIBezierPath) {
        path.move(to: CGPoint(x: 30, y: 20))
        path.addLine(to: CGPoint(x: 50, y: 20))
        path.addClip()
    }
}

// MARK: - Square Drawing

extension PlayingCardView {
    func squarePath() {
        colorPath(.red)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 80, y: 20))
        path.addLine(to: CGPoint(x: 110, y: 20))
        path.addLine(to: CGPoint(x: 110, y: 50))
        path.addLine(to: CGPoint(x: 80, y: 50))
        path.close()
        
        path.lineWidth = 3.0
        stripedSquare(path: path)
    }
    
    func stripedSquare(path: UIBezierPath) {
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

