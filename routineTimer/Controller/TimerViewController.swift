//taskTitle反映
//残り時間反映
//<>ボタンでタイマーを進めるようにする
//タイマーが全部終了したら完了ラベル出現させる
//音声や効果音を追加する
//ボタンを押したときの軽いアニメーション

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    private var shapeLayerA = CAShapeLayer()
    private var shapeLayerB = CAShapeLayer()
    private var pulsatingLayer: CAShapeLayer!
    private var timer = Timer()
    //残り時間
    private var timeRemainingA:Float = 60
    private var timeRemainingB:Float = 300
    //スタート時点の残り時間
    private var timeStartA:Int = 60
    private var timeStartB:Int = 300
    var timerCounting: Bool = false
    
    
    
    
    //---------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        //タイトルの色
        taskTitle.textColor = .color4
        //ボタンの丸み
        startStopButton.layer.cornerRadius = 50
        minusButton.layer.cornerRadius = 25
        plusButton.layer.cornerRadius = 25
        //ボタンのテキストの色
        startStopButton.titleLabel?.textColor = .color4
        minusButton.titleLabel?.textColor = .color4
        plusButton.titleLabel?.textColor = .color4
        //ボタンの背景色
        startStopButton.backgroundColor = .color3
        minusButton.backgroundColor = .color3
        plusButton.backgroundColor = .color3
        
        //背景の色
        view.backgroundColor = .color1
        
        //残り時間表示ラベル
        timerLabel.text = "START"
        timerLabel.textAlignment = .center
        timerLabel.font = .boldSystemFont(ofSize: 40)
        timerLabel.textColor = .color4
        timerLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        timerLabel.center = view.center
        
        setupCircleLayers()
        view.addSubview(timerLabel)
    }
    //---------------------------------------------------------------------------------------

    
    private func createCircleShapeLayerA(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: view.frame.width / 2.5, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 10
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = view.center
        return layer
    }
    private func createCircleShapeLayerB(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: (view.frame.width / 2.5) - 15, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 10
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = view.center
        return layer
    }
    private func setupCircleLayers() {
        
        pulsatingLayer = createCircleShapeLayerA(strokeColor: .color3, fillColor: .color2)
        view.layer.addSublayer(pulsatingLayer)
        //animatePulsatingLayer()

        let trackLayerA = createCircleShapeLayerA(strokeColor: .color2, fillColor: .color1)
        view.layer.addSublayer(trackLayerA)
        let trackLayerB = createCircleShapeLayerB(strokeColor: .color2, fillColor: .color1)
        view.layer.addSublayer(trackLayerB)

        shapeLayerA = createCircleShapeLayerA(strokeColor: .color3, fillColor: .clear)
        shapeLayerA.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayerA.strokeEnd = 0
        
        shapeLayerB = createCircleShapeLayerB(strokeColor: .systemOrange, fillColor: .clear)
        shapeLayerB.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayerB.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayerA)
        view.layer.addSublayer(shapeLayerB)
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
        shapeLayerA.add(basicAnimation, forKey: "urSoBasic")
        shapeLayerB.add(basicAnimation, forKey: "urSoBasic")
    }
    
    //-----------------------------------------------------
    
    @IBAction func backButton(_ sender: Any) {
        //ボタンの振動
        Feedbacker.impact(style: .medium)
    }
    @IBAction func nextButton(_ sender: Any) {
        //ボタンの振動
        Feedbacker.impact(style: .medium)
    }
    
    
    
    @IBAction func startStopButton(_ sender: UIButton) {
        
        if(timerCounting){
            timerCounting = false
            startStopButton.setTitle("START", for: .normal)
            startStopButton.backgroundColor = .color3
            //STOPボタンの役割
            timer.invalidate()
            
        } else {
            timerCounting = true
            //水面アニメーション
//            let pulse = PulsingAnimation(numberOfPulses: 1, radius: 100, position: startStopButton.center)
//            pulse.animationDuration = 1.0
//            pulse.backgroundColor = CGColor.init(red: 0, green: 173, blue: 181, alpha: 20)
//            self.view.layer.insertSublayer(pulse, below: self.view.layer)
            
            startStopButton.setTitle("STOP", for: .normal)
            startStopButton.backgroundColor = UIColor.rgb(r: 234, g: 84, b: 85)
            
            //STARTボタンの役割
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.1,
                                         target: self,
                                         selector: #selector(TimerViewController.timerClass),
                                         userInfo: nil,
                                         repeats: true)
            animateCircle()
            
        }
        
        //ボタンの振動
        Feedbacker.impact(style: .medium)
        
        }
        

    @IBAction func minusButton(_ sender: Any) {
        
        timeRemainingA -= 5
        timeRemainingB -= 5
        timerLabel.text = "残り \n\(Int(timeRemainingA))"
        animateCircle()
        
        //ボタンの振動
        Feedbacker.impact(style: .medium)
        
    }
    @IBAction func plusButton(_ sender: Any) {
        timeRemainingA += 5
        timeRemainingB += 5
        timerLabel.text = "残り \n\(Int(timeRemainingA))"
        animateCircle()
        
        //ボタンの振動
        Feedbacker.impact(style: .medium)
        
    }
    
    //------------------------------------------------------
    
    @objc func timerClass() {
        
        if timeRemainingA > 0 {
            timeRemainingA -= 0.1
            timeRemainingB -= 0.1
        } else {
            timer.invalidate()
            timeRemainingA = 60
            timeRemainingB = 300
        }
        
        let percentageA = CGFloat(1 - Float(timeRemainingA) * 1 / Float(timeStartA))
        let percentageB = CGFloat(1 - Float(timeRemainingB) * 1 / Float(timeStartB))
        self.shapeLayerA.strokeEnd = percentageA
        self.shapeLayerB.strokeEnd = percentageB
        
        timerLabel.text = "残り \n\(Int(timeRemainingA))"
        print("割合は\(percentageA)")
    }
    
}
