//
//  loaderAnimation.swift
//  iOSLearningApp
//
//  Created by Ritik Raj on 18/09/22.
//

import Foundation
import UIKit

class ProgressView: UIView {
    
    init(frame: CGRect,
             colors: [UIColor],
             lineWidth: CGFloat
        ) {
            self.colors = colors
            self.lineWidth = lineWidth
            
            super.init(frame: frame)
            
            self.backgroundColor = .clear
        }
        
        // 2
        convenience init(colors: [UIColor], lineWidth: CGFloat) {
            self.init(frame: .zero, colors: colors, lineWidth: lineWidth)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) is not supported")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            self.layer.cornerRadius = self.frame.width / 2
            
            // 3
            let path = UIBezierPath(ovalIn:
                CGRect(
                    x: 0,
                    y: 0,
                    width: self.bounds.width,
                    height: self.bounds.width
                )
            )

            shapeLayer.path = path.cgPath
        }
        
        // 4
        let colors: [UIColor]
        let lineWidth: CGFloat
        
        // 5
        private lazy var shapeLayer: ProgressShapeLayer = {
            return ProgressShapeLayer(strokeColor: colors.first!, lineWidth: lineWidth)
        }()
    
    func animateStroke() {
            
            // 1
            let startAnimation = StrokeAnimation(
                type: .start,
                beginTime: 0.25,
                fromValue: 0.0,
                toValue: 1.0,
                duration: 0.75
            )
            // 2
            let endAnimation = StrokeAnimation(
                type: .end,
                fromValue: 0.0,
                toValue: 1.0,
                duration: 0.75
            )
            // 3
            let strokeAnimationGroup = CAAnimationGroup()
            strokeAnimationGroup.duration = 1
            strokeAnimationGroup.repeatDuration = .infinity
            strokeAnimationGroup.animations = [startAnimation, endAnimation]
            // 4
            shapeLayer.add(strokeAnimationGroup, forKey: nil)
            // 5
            self.layer.addSublayer(shapeLayer)
        }
}

class ProgressShapeLayer: CAShapeLayer {
    
    public init(strokeColor: UIColor, lineWidth: CGFloat) {
        super.init()
        
        self.strokeColor = strokeColor.cgColor
        self.lineWidth = lineWidth
        self.fillColor = UIColor.clear.cgColor
        self.lineCap = .round
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StrokeAnimation: CABasicAnimation {
    
    // 1
    enum StrokeType {
        case start
        case end
    }
    
    // 2
    override init() {
        super.init()
    }
    
    // 3
    init(type: StrokeType,
         beginTime: Double = 0.0,
         fromValue: CGFloat,
         toValue: CGFloat,
         duration: Double) {
        
        super.init()
        
        self.keyPath = type == .start ? "strokeStart" : "strokeEnd"
        
        self.beginTime = beginTime
        self.fromValue = fromValue
        self.toValue = toValue
        self.duration = duration
        self.timingFunction = .init(name: .easeInEaseOut)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


