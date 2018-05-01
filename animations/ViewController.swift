//
//  ViewController.swift
//  animations
//
//  Created by Duncan MacDonald on 4/30/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        let solid = MetatronSolid(frame: view.frame, type: .cube)
        solid.backgroundColor = UIColor.clear
        view.addSubview(solid)
        view.layoutSubviews()
    }
}

enum MetatronType {
    case tetrahedron
    case starTetrahedron
    case cube
    case octahedron
    case dodecahedron
    case icosahedron
}

class MetatronSolid: UIView {
    var screenSize: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var nodes: [Ring] = []
    
    init(frame: CGRect, type: MetatronType) {
        super.init(frame: frame)
        screenSize = UIScreen.main.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        drawNodes()
        drawLines()
    }
    
    internal func drawNodes() -> () {
        let radius: CGFloat = 30
        
        // a^2 + b^2 = c^2
        // r^2 + b^2 = 2r^2
        // b^2 = 2r^2 - r^2
        
        let offset: CGFloat = sqrt( pow(2 * radius, 2) - pow(radius, 2) )
        
        let topWidth: CGFloat = sqrt( pow(4 * radius, 2) - pow(2 * radius, 2) )
        
        var node1Point = CGPoint(x: (screenSize.width / 2) - radius, y: 300)
        var node2Point = CGPoint(x: node1Point.x + topWidth, y: node1Point.y - (radius * 2))
        var node3Point = CGPoint(x: node1Point.x + topWidth, y: node1Point.y - (radius * 6))
        
        for _ in 1...5 {
            let node1 = Ring(frame: CGRect(x: node1Point.x, y: node1Point.y, width: radius * 2, height: radius * 2))
            node1.backgroundColor = UIColor.clear
            
            let node2 = Ring(frame: CGRect(x: node2Point.x, y: node2Point.y, width: radius * 2, height: radius * 2))
            node2.backgroundColor = UIColor.clear
            
            let node3 = Ring(frame: CGRect(x: node3Point.x, y: node3Point.y, width: radius * 2, height: radius * 2))
            node3.backgroundColor = UIColor.clear
            
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
        let lineWidth: CGFloat = 1
        let lineColor: CGColor = UIColor.black.cgColor
        let group = CAAnimationGroup()
        
        for ring in nodes {
            for target in nodes {
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
                animation.duration = 5
                animation.toValue = 2
                animation.isRemovedOnCompletion = false
                animation.repeatCount = .infinity
                animation.autoreverses = true
                shapeLayer.add(animation, forKey: "myanim")
                
                group.animations?.append(animation)
            }
        }
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
