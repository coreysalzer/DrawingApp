//
//  DrawingCanvas.swift
//  CoreySalzer-Lab3
//
//  Created by Corey Salzer on 2/13/17.
//  Copyright © 2017 Corey Salzer. All rights reserved.
//

import Foundation
import UIKit

class StrokeView : UIView {

    var stroke:Stroke? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        stroke!.color.setFill()
        
        var path = UIBezierPath()
        path.addArc(withCenter: stroke!.points[0], radius: (stroke!.thickness)/4, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        if(stroke!.points.count <= 2) {
            path.fill()
        }
        else {
            path = createQuadPath(points: stroke!.points)
        }
        path.lineWidth = stroke!.thickness
        stroke!.color.setStroke()
        path.stroke()
    }
    
    func createQuadPath(points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        if points.count < 2 { return path }
        let firstPoint = points[0]
        let secondPoint = points[1]
        let firstMidpoint = midpoint(first: firstPoint, second: secondPoint)
        path.move(to: firstPoint)
        path.addLine(to: firstMidpoint)
        for index in 1 ..< points.count-1 {
            let currentPoint = points[index]
            let nextPoint = points[index + 1]
            let midPoint = midpoint(first: currentPoint, second: nextPoint)
            path.addQuadCurve(to: midPoint, controlPoint: currentPoint)
        }
        guard let lastLocation = points.last else { return path }
        path.addLine(to: lastLocation)
        return path
    }
    
    private func midpoint(first: CGPoint, second: CGPoint) -> CGPoint {
        return CGPoint(x: (first.x + second.x)/2, y: (first.y + second.y)/2)
    }
}
