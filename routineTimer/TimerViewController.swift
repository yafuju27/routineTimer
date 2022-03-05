//
//  TimerViewController.swift
//  routineTimer
//
//  Created by Yazici Yahya on 2022/02/27.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    private var shapeLayer = CAShapeLayer()
    private var pulsatingLayer: CAShapeLayer!
    private var timer = Timer()
    //残り時間
    private var timeRemaining:Float = 60
    //スタート時点の残り時間
    private var timeStart:Int = 60
    
    
    //---------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        //タイトルの色
        taskTitle.textColor = .color4
        //ボタンの丸み
        playButton.layer.cornerRadius = 12
        pauseButton.layer.cornerRadius = 12
        minusButton.layer.cornerRadius = 12
        plusButton.layer.cornerRadius = 12
        //ボタンのテキストの色
        playButton.titleLabel?.textColor = .color4
        pauseButton.titleLabel?.textColor = .color4
        minusButton.titleLabel?.textColor = .color4
        plusButton.titleLabel?.textColor = .color4
        //ボタンの背景色
        playButton.backgroundColor = .color3
        pauseButton.backgroundColor = .color3
        minusButton.backgroundColor = .color3
        plusButton.backgroundColor = .color3
        
        //背景の色
        view.backgroundColor = .color1
        
        //残り時間表示ラベル
        timerLabel.text = "Start"
        timerLabel.textAlignment = .center
        timerLabel.font = .boldSystemFont(ofSize: 40)
        timerLabel.textColor = .color4
        timerLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        timerLabel.center = view.center
        
        setupCircleLayers()
        view.addSubview(timerLabel)
        
        
        
        
    }
    //---------------------------------------------------------------------------------------

    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 120, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 10
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = view.center
        return layer
    }
    
    private func setupCircleLayers() {
        
        pulsatingLayer = createCircleShapeLayer(strokeColor: .color2, fillColor: .color2)
        view.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()

        let trackLayer = createCircleShapeLayer(strokeColor: .color3, fillColor: .color1)
        view.layer.addSublayer(trackLayer)

        shapeLayer = createCircleShapeLayer(strokeColor: .color4, fillColor: .clear)
        
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.2
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    

    fileprivate func animateCircle(){
        //アニメーションに関してはここで完結している
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        //basicAnimation.toValue = 1
        //basicAnimation.duration = 2
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
  

    
    //-----------------------------------------------------
    
    @IBAction func backButton(_ sender: Any) {
    }
    @IBAction func nextButton(_ sender: Any) {
    }
    @IBAction func playButton(_ sender: Any) {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(TimerViewController.timerClass),
                                     userInfo: nil,
                                     repeats: true)
        animateCircle()
    }
    @IBAction func pauseButton(_ sender: Any) {
        timer.invalidate()
    }
    
    @IBAction func minusButton(_ sender: Any) {
        timeRemaining -= 5
        timerLabel.text = "残り \n\(Int(timeRemaining))"
    }
    @IBAction func plusButton(_ sender: Any) {
        timeRemaining += 5
        timerLabel.text = "残り \n\(Int(timeRemaining))"
    }
    
    
    //------------------------------------------------------
    
    
    
    @objc func timerClass() {
        
        if timeRemaining > 0 {
            timeRemaining -= 0.1
        } else {
            timer.invalidate()
            timeRemaining = 60
        }
        
        let percentage = CGFloat(1 - Float(timeRemaining) * 1 / Float(timeStart))
        self.shapeLayer.strokeEnd = percentage
        
        timerLabel.text = "残り \n\(Int(timeRemaining))"
        print("割合は\(percentage)")
    }
    
    
    
    
    
    
    
}
