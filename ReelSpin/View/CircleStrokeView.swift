//
//  CircleStrokeView.swift
//  ReelSpin
//
//  Created by mike liu on 2025/5/3.
//

import UIKit

@IBDesignable
final class CircleStrokeView: UIView {

    // MARK: – Inspectables
    @IBInspectable var strokeColor: UIColor = .systemBlue {
        didSet { shapeLayer.strokeColor = strokeColor.cgColor }
    }
    @IBInspectable var lineWidth: CGFloat = 6 {
        didSet { shapeLayer.lineWidth = lineWidth }
    }
    @IBInspectable var animationDuration: Double = 1.5

    // MARK: – Private
    private var shapeLayer: CAShapeLayer { layer as! CAShapeLayer }

    override class var layerClass: AnyClass { CAShapeLayer.self }

    // MARK: – Init
    override init(frame: CGRect) { super.init(frame: frame); commonInit() }
    required init?(coder: NSCoder) { super.init(coder: coder); commonInit() }

    private func commonInit() {
        backgroundColor = .clear
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
    }

    // MARK: – Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = min(bounds.width, bounds.height) * 0.5 - lineWidth * 0.5
        let path = UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: .pi * 1.5,
            clockwise: true)
        shapeLayer.path = path.cgPath
    }

    // MARK: – API
    // 在外部需要時呼叫；completion 於動畫真正結束後執行
    func animateOnce(completion: (() -> Void)? = nil) {
        shapeLayer.removeAllAnimations()
        shapeLayer.strokeEnd = 0

        // 用 CATransaction 監聽結束，比 delegate 簡潔
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?()          // 🎯 告訴外部「我畫完了」
        }

        let anim          = CABasicAnimation(keyPath: "strokeEnd")
        anim.fromValue    = 0
        anim.toValue      = 1
        anim.duration     = animationDuration
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        anim.fillMode     = .forwards
        anim.isRemovedOnCompletion = false

        shapeLayer.add(anim, forKey: "strokeEndAnim")
        CATransaction.commit()
    }

}
