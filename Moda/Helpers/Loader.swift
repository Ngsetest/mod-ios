//
//  Loader.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/23/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class Loader: CAShapeLayer {

    // MARK: - Private properties

    private let superView: UIView
    private let viewsToHide: [UIView]
    private lazy var loader: CAShapeLayer = {
        let shape = UIBezierPath()
        shape.move(to: CGPoint(x: 87.64, y: 49.71))
        shape.addCurve(to: CGPoint(x: 88.12, y: 63.43), controlPoint1: CGPoint(x: 87.86, y: 53.71), controlPoint2: CGPoint(x: 88.18, y: 57.46))
        shape.addCurve(to: CGPoint(x: 87.12, y: 75.68), controlPoint1: CGPoint(x: 87.97, y: 67.08), controlPoint2: CGPoint(x: 88.12, y: 70.84))
        shape.addCurve(to: CGPoint(x: 86.12, y: 79.14), controlPoint1: CGPoint(x: 86.84, y: 77.02), controlPoint2: CGPoint(x: 86.12, y: 79.14))
        shape.addCurve(to: CGPoint(x: 74.05, y: 88.27), controlPoint1: CGPoint(x: 84.33, y: 84.36), controlPoint2: CGPoint(x: 79.56, y: 87.97))
        shape.addCurve(to: CGPoint(x: 61.05, y: 88.27), controlPoint1: CGPoint(x: 69.73, y: 88.61), controlPoint2: CGPoint(x: 65.38, y: 88.61))
        shape.addCurve(to: CGPoint(x: 35.17, y: 83.77), controlPoint1: CGPoint(x: 52.29, y: 87.69), controlPoint2: CGPoint(x: 43.62, y: 86.18))
        shape.addCurve(to: CGPoint(x: 12.98, y: 74.43), controlPoint1: CGPoint(x: 27.45, y: 81.52), controlPoint2: CGPoint(x: 20, y: 78.38))
        shape.addCurve(to: CGPoint(x: 8.48, y: 72.01), controlPoint1: CGPoint(x: 11.49, y: 73.61), controlPoint2: CGPoint(x: 9.98, y: 72.89))
        shape.addCurve(to: CGPoint(x: 0.87, y: 52.7), controlPoint1: CGPoint(x: 0.98, y: 67.5), controlPoint2: CGPoint(x: -1.52, y: 61.13))
        shape.addCurve(to: CGPoint(x: 10.14, y: 35.39), controlPoint1: CGPoint(x: 2.83, y: 46.39), controlPoint2: CGPoint(x: 5.98, y: 40.52))
        shape.addCurve(to: CGPoint(x: 52.91, y: 2.06), controlPoint1: CGPoint(x: 21.42, y: 20.91), controlPoint2: CGPoint(x: 36.12, y: 9.46))
        shape.addCurve(to: CGPoint(x: 66.19, y: 0.73), controlPoint1: CGPoint(x: 57.16, y: 0.15), controlPoint2: CGPoint(x: 61.58, y: -0.74))
        shape.addCurve(to: CGPoint(x: 75.46, y: 7.86), controlPoint1: CGPoint(x: 69.97, y: 2.05), controlPoint2: CGPoint(x: 73.22, y: 4.55))
        shape.addCurve(to: CGPoint(x: 83.51, y: 24.95), controlPoint1: CGPoint(x: 79.33, y: 12.96), controlPoint2: CGPoint(x: 81.64, y: 18.86))
        shape.addCurve(to: CGPoint(x: 87.64, y: 49.71), controlPoint1: CGPoint(x: 85.88, y: 33.01), controlPoint2: CGPoint(x: 87.26, y: 41.33))
        shape.move(to: CGPoint(x: 69.42, y: 17.36))
        shape.addCurve(to: CGPoint(x: 67.46, y: 12.54), controlPoint1: CGPoint(x: 69.44, y: 15.56), controlPoint2: CGPoint(x: 68.73, y: 13.82))
        shape.addCurve(to: CGPoint(x: 62.64, y: 10.54), controlPoint1: CGPoint(x: 66.18, y: 11.26), controlPoint2: CGPoint(x: 64.45, y: 10.54))
        shape.addCurve(to: CGPoint(x: 56.29, y: 14.7), controlPoint1: CGPoint(x: 59.88, y: 10.51), controlPoint2: CGPoint(x: 57.37, y: 12.15))
        shape.addCurve(to: CGPoint(x: 57.71, y: 22.16), controlPoint1: CGPoint(x: 55.21, y: 17.24), controlPoint2: CGPoint(x: 55.77, y: 20.19))
        shape.addCurve(to: CGPoint(x: 65.16, y: 23.67), controlPoint1: CGPoint(x: 59.66, y: 24.12), controlPoint2: CGPoint(x: 62.6, y: 24.72))
        shape.addCurve(to: CGPoint(x: 69.38, y: 17.36), controlPoint1: CGPoint(x: 67.71, y: 22.62), controlPoint2: CGPoint(x: 69.38, y: 20.13))

        let shapeLayer: CAShapeLayer = {
            $0.frame = CGRect(x: superView.frame.midX - 50, y: superView.frame.midY - 50, width: 100, height: 100)
            $0.path = shape.cgPath
            $0.fillColor = kColor_White.cgColor
            $0.lineWidth = 2.0
            $0.strokeColor = kColor_AppOrange.cgColor
            return $0
        }(CAShapeLayer())

        shapeLayer.strokeStart = 0.0
        shapeLayer.strokeEnd = 0.0

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.toValue = 1.0
        strokeEndAnimation.duration = 1.2
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        strokeEndAnimation.repeatCount = .greatestFiniteMagnitude

        shapeLayer.add(strokeEndAnimation, forKey: "strokeEndAnimation")

        return shapeLayer
    }()

    // MARK: - Main interface

    func start() {
        viewsToHide.forEach { $0.isHidden = true }
        superView.layer.addSublayer(loader)
    }

    func stop() {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.loader.removeFromSuperlayer()
                self.viewsToHide.forEach { $0.isHidden = false }
            }
        ) { succes in
            // ...
        }
    }

    // MARK: - Initializers

    init(superView: UIView, viewsToHide: [UIView]) {
        self.superView = superView
        self.viewsToHide = viewsToHide

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
