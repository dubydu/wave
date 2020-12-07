//
//  ViewController.swift
//  Waves
//
//  Created by DU on 06/12/2020.
//

// Reference: https://en.wikipedia.org/wiki/Wave

import UIKit

class ViewController: UIViewController {
    // MARK: - UI
    @IBOutlet weak var distanceSlider: UISlider!

    // MARK: - Properties
    /// A timer object that allows your application to
    /// synchronize its drawing to the refresh rate of the display
    private var displayLink: CADisplayLink?
    /// Frequence visual
    private let shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3
        return shapeLayer
    }()
    /// Waves values
    private var lamda: CGFloat = 3
    private var amplitude: CGFloat = 30

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private Methods
    private func setupUI() {
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector:#selector(handleDisplayLink(_:)))
        displayLink?.add(to: .main, forMode: .common)
        distanceSlider.value = Float(lamda)
        view.layer.addSublayer(shapeLayer)
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
    }

    @objc func handleDisplayLink(_ displayLink: CADisplayLink) {
        shapeLayer.path = wave(at: CACurrentMediaTime()).cgPath
    }
}

// MARK: - Drawing
extension ViewController {
    /// Drawing the frequence
    ///
    /// - Parameter elapsed: The timer
    /// - Return: UIBezierPath
    func wave(at elapsed: Double) -> UIBezierPath {
        let elapsed = CGFloat(elapsed)
        let centerY = view.bounds.midY
        func frequence(_ x: CGFloat) -> CGFloat {
            return sin((x + elapsed) * self.lamda * .pi) * amplitude + centerY
        }
        let path = UIBezierPath()
        let steps = Int(view.bounds.width / 4)
        path.move(to: CGPoint(x: 0, y: frequence(0)))
        for step in 1 ... steps {
            let x = CGFloat(step) / CGFloat(steps)
            path.addLine(to: CGPoint(x: x * view.bounds.width, y: frequence(x)))
        }
        return path
    }
}

// MARK: - Speed Control
extension ViewController {
    /// Change the lamda value
    ///
    /// - Parameter slider: value of lamda (0 - 6)
    @IBAction func valueChanged(_ slider: UISlider) {
        self.lamda = CGFloat(slider.value)
    }
}
