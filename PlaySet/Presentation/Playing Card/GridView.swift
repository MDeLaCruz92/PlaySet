//
//  GridView.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 6/16/21.
//  Copyright © 2021 Michael De La Cruz. All rights reserved.
//

import UIKit

@IBDesignable
class GridView: UIView {
    
    let cardView = PlayingCardView()
    
    lazy var gridDimenions = Grid(layout: .dimensions(rowCount: GridMatrix.rowCount, columnCount: GridMatrix.columnCount), frame: frame)
    
    lazy var gridCellSize = Grid(layout: .fixedCellSize(frame.size))
    
    lazy var gridAspectRatio = Grid(layout: .aspectRatio(30.0))
    
    override func draw(_ rect: CGRect) {
        let grid = Grid(layout: .fixedCellSize(frame.size), frame: frame)
        let roundedRect = UIBezierPath(roundedRect: grid.frame, cornerRadius: 16)
        #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1).setFill()
        roundedRect.fill()
    }
}

extension GridView {
    private struct GridMatrix {
        static let rowCount: Int = 3
        static let columnCount: Int = 7
    }
}
