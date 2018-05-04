//
//  MetatronSolid.swift
//  animations
//
//  Created by Duncan MacDonald on 5/1/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

enum MetatronType {
    case tetrahedron
    case cube
    case octahedron
    case icosahedron
    case metatron
}

class MetatronSolid: UIView {
    var screenSize: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var nodes: [Ring] = []
    
    var shape: MetatronType {
        didSet {
            reloadOptions()
        }
    }
    
    let lineWidth: CGFloat = 2
    let lineColor: CGColor = UIColor.red.cgColor
    
    var drawStencil: Bool {
        didSet {
            reloadOptions()
        }
    }
    
    var shouldRepeat: Bool {
        didSet {
            reloadOptions()
        }
    }
    
    func reloadOptions() {
        super.layer.sublayers?.forEach({ $0.removeAllAnimations() })
        setNeedsDisplay()
    }
    
    init(frame: CGRect, type: MetatronType, drawStencil: Bool = true, shouldRepeat: Bool = false) {
        self.shape = type
        self.drawStencil = drawStencil
        self.shouldRepeat = shouldRepeat
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = false
        screenSize = UIScreen.main.bounds
        drawNodes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if drawStencil {
            drawLines()
        }
            
        switch shape {
        case .tetrahedron:
            drawTetrahedron()
        case .cube:
            drawCube()
        case .octahedron:
            drawOctahedron()
        case .icosahedron:
            drawIcosahedron()
        case .metatron:
            drawCube()
            drawIcosahedron()
            drawOctahedron()
            drawTetrahedron()
        }
    }
    
    internal func drawNodes() -> () {
        let radius: CGFloat = 30
        
        // a^2 + b^2 = c^2
        // r^2 + b^2 = 2r^2
        // b^2 = 2r^2 - r^2
        
        let offset: CGFloat = sqrt( pow(2 * radius, 2) - pow(radius, 2) )
        
        let topWidth: CGFloat = sqrt( pow(4 * radius, 2) - pow(2 * radius, 2) )
        
        var node1Point = CGPoint(x: (screenSize.width / 2) - radius, y: screenSize.height / 2)
        var node2Point = CGPoint(x: node1Point.x + topWidth, y: node1Point.y - (radius * 2))
        var node3Point = CGPoint(x: node1Point.x + topWidth, y: node1Point.y - (radius * 6))
        
        for _ in 1...5 {
            let node1 = Ring(frame: CGRect(x: node1Point.x, y: node1Point.y, width: radius * 2, height: radius * 2))
            node1.backgroundColor = UIColor.clear
            node1.tag = 15
            
            let node2 = Ring(frame: CGRect(x: node2Point.x, y: node2Point.y, width: radius * 2, height: radius * 2))
            node2.backgroundColor = UIColor.clear
            node2.tag = 15
            
            let node3 = Ring(frame: CGRect(x: node3Point.x, y: node3Point.y, width: radius * 2, height: radius * 2))
            node3.backgroundColor = UIColor.clear
            node3.tag = 15
            
            super.addSubview(node1)
            super.addSubview(node2)
            super.addSubview(node3)
            
            nodes.append(contentsOf: [node1, node2, node3])
            
            node1Point.y = node1Point.y - (radius * 2)
            
            node2Point.x = node2Point.x - offset
            node2Point.y = node2Point.y - radius
            
            node3Point.x = node3Point.x - offset
            node3Point.y = node3Point.y + radius
        }
        super.layoutSubviews()
    }
    
    internal func drawLines() -> () {
        
        for ring in nodes {
            for target in nodes {
                let linePath = UIBezierPath()
                linePath.move(to: ring.center)
                linePath.addLine(to: target.center)
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = linePath.cgPath
                shapeLayer.strokeColor = UIColor.darkGray.cgColor
                shapeLayer.fillColor = UIColor.clear.cgColor
                shapeLayer.lineWidth = 1
                shapeLayer.strokeEnd = 0
                
                layer.addSublayer(shapeLayer)
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.duration = 2
                animation.fromValue = -0.5
                animation.toValue = 2
                animation.isRemovedOnCompletion = false
                animation.repeatCount = shouldRepeat ? Float.infinity : 0
                animation.autoreverses = true
                shapeLayer.add(animation, forKey: "myanim")
            }
        }
    }
    
    internal func drawCube() -> () {
        
        let cube: [[Int]] = [[0, 1], [1, 2], [2, 12], [12, 13], [13, 14], [14, 0],
                             [3, 4], [4, 5], [5, 9], [9, 10], [10, 11], [11, 3],
                             [0, 6], [1, 6], [2, 6], [12, 6], [13, 6], [14, 6]]
        
        drawAnim(coords: cube)
    }
    
    func drawAnim(coords: [[Int]], fromValue: Float = -1.5, toValue: Float = 2, doesAutoreverse: Bool = true) {
        for coord in coords {
            let ring = nodes[coord[0]]
            let target = nodes[coord[1]]
            
            let linePath = UIBezierPath()
            linePath.move(to: ring.center)
            linePath.addLine(to: target.center)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = linePath.cgPath
            shapeLayer.strokeColor = lineColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = lineWidth
            shapeLayer.strokeEnd = 0
            
            layer.addSublayer(shapeLayer)
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 2
            animation.fromValue = fromValue
            animation.toValue = toValue
            animation.isRemovedOnCompletion = false
            animation.repeatCount = shouldRepeat ? Float.infinity : 0
            animation.autoreverses = doesAutoreverse
            shapeLayer.add(animation, forKey: "myanim")
        }
    }
    
    internal func drawIcosahedron() -> () {
        let coords: [[Int]] = [[0, 1], [1, 2], [2, 12], [12, 13], [13, 14], [14, 0],
                               [13, 10], [0, 3], [2, 5],
                               [12, 14], [14, 1], [1, 12],
                               [10, 5], [5, 3], [3, 10]]
        
        drawAnim(coords: coords)
    }
    
    internal func drawOctahedron() -> () {
        let coords: [[Int]] = [[0, 1], [1, 2], [2, 12], [12, 13], [13, 14], [14, 0],
                               [3, 4], [4, 5], [5, 9], [9, 10], [10, 11], [11, 3],
                               [12, 14], [14, 1], [1, 12],
                               [13, 2], [2, 0], [0, 13],
                               [10, 5], [5, 3], [3, 10],
                               [11, 4], [4, 9], [9, 11]]
        
        drawAnim(coords: coords)
    }
    
    internal func drawTetrahedron() -> () {
        let coords: [[Int]] = [[12, 14], [14, 1], [1, 12],
                               [13, 2], [2, 0], [0, 13],
                               [11, 4], [4, 9], [9, 11],
                               [12, 6], [14, 6], [1, 6]]
        
        drawAnim(coords: coords)
    }
}

class Ring: UIView {
    override func draw(_ rect: CGRect) {
        drawRingFittingInsideView()
    }
    
    internal func drawRingFittingInsideView() -> () {
        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth:CGFloat = 1
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x:halfSize,y:halfSize),
            radius: CGFloat( halfSize - (desiredLineWidth/2) ),
            startAngle: CGFloat(0),
            endAngle:CGFloat(Double.pi * 2),
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = desiredLineWidth
        
        layer.addSublayer(shapeLayer)
    }
}
