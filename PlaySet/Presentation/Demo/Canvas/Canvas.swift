//
//  Canvas.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 3/2/19.
//  Copyright © 2019 Michael De La Cruz. All rights reserved.
//

import UIKit

class Canvas: UIView  {
    
    fileprivate var lines = [Line]()
    
    fileprivate var strokeColor = UIColor.black
    fileprivate var strokeWidth: Float  = 1
    
    override func draw(_ rect: CGRect) {
        // custom drawing
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        lines.forEach{ (line) in
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(CGFloat(line.strokeWidth))
            context.setLineCap(.round)
            for (index, point) in line.points.enumerated() {
                if index == 0 {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
            }
            context.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(Line.init(strokeWidth: strokeWidth, color: strokeColor, points: []))
    }
    
    // track the finger as we move across screen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else {  return }
        
        guard var lastLine = lines.popLast() else { return }
        lastLine.points.append(point)
        lines.append(lastLine)
        
        setNeedsDisplay()
    }
    
    func setStrokeColor(color: UIColor) {
        self.strokeColor = color
    }
    
   func  setStrokeWidth(width: Float) {
        self.strokeWidth = width
    }
    
    func undo() {
        _ =  lines.popLast()
        setNeedsDisplay()
    }
    
    func clear() {
        lines.removeAll()
        setNeedsDisplay()
    }
}
