//
//  ProductCollectionViewCellDesign.swift
//  Moda
//
//  Created by admin_user on 3/17/19.
//  Copyright © 2019 moda. All rights reserved.
//

import Foundation

extension CAShapeLayer {
    func drawHeart(in viewRect: CGRect, isFilled : Bool) {
        frame = CGRect(x: viewRect.maxX - 30, y: 12, width: 20, height: 20)
        let color = UIColor.darkGray
        lineWidth = 1
        
        if isFilled {
            fillColor = color.cgColor
            strokeColor  = kColor_No.cgColor
            
        } else {
            fillColor = kColor_No.cgColor
            strokeColor  = color.cgColor
        }
        
        path = UIBezierPath(heartIn: CGRect(x: 0, y: 0, width: 20, height: 20)).cgPath
    }
}

extension CATextLayer {
    
    func drawNewLabel(in viewRect: CGRect, andColor color: UIColor) {
        frame = CGRect(x: viewRect.origin.x, y: viewRect.maxY - 36, width: 35, height: 18)
        string = "NEW"
        foregroundColor = color.cgColor
        fontSize = 10
        alignmentMode = kCAAlignmentCenter
        backgroundColor = kColor_Red.cgColor
        opacity = 1
        contentsScale = UIScreen.main.scale
    }
    
    func drawAvailableLabel(in viewRect: CGRect, andColor color: UIColor) {
        frame = CGRect(x: viewRect.origin.x, y: viewRect.maxY - 36+20, width: 70, height: 18)
        string = kEmpty//В НАЛИЧИИ"
        foregroundColor = color.cgColor
        fontSize = 10
        alignmentMode = kCAAlignmentCenter
        backgroundColor = kColor_No.cgColor
        opacity = 1
        contentsScale = UIScreen.main.scale
    }
    
    func drawSaleLabel(in viewRect: CGRect, andColor color: UIColor, percent: String) {
        frame = CGRect(x: viewRect.origin.x, y: viewRect.maxY - 36, width: 35, height: 18)
        string = percent
        foregroundColor = kColor_White.cgColor
        fontSize = 10
        alignmentMode = kCAAlignmentCenter
        backgroundColor = color.cgColor
        opacity = 1
        contentsScale = UIScreen.main.scale
    }
    
    func drawPremiumLabel(in viewRect: CGRect, andColor color: UIColor) {
        frame = CGRect(x: viewRect.origin.x, y: viewRect.origin.y + 15, width: 55, height: 18)
        string = "PREMIUM"
        foregroundColor = kColor_White.cgColor
        fontSize = 10
        alignmentMode = kCAAlignmentCenter
        backgroundColor = color.cgColor
        opacity = 1
        contentsScale = UIScreen.main.scale
    }
}



extension UIBezierPath {
    convenience init(heartIn rect: CGRect) {
        self.init()
        
        let sideOne = rect.width * 0.4
        let sideTwo = rect.height * 0.3
        let arcRadius = sqrt(sideOne * sideOne + sideTwo * sideTwo) / 2
        
        addArc(
            withCenter: CGPoint(x: rect.width * 0.3, y: rect.height * 0.35),
            radius: arcRadius,
            startAngle: 135.degreesToRadians,
            endAngle: 315.degreesToRadians,
            clockwise: true
        )
        addLine(to: CGPoint(x: rect.width / 2, y: rect.height * 0.2))
        addArc(
            withCenter: CGPoint(x: rect.width * 0.7, y: rect.height * 0.35),
            radius: arcRadius,
            startAngle: 225.degreesToRadians,
            endAngle: 45.degreesToRadians,
            clockwise: true
        )
        addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.95))
        
        close()
    }
}

