import UIKit
import AVFoundation

class TimerViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    private var shapeLayerA = CAShapeLayer()
    private var shapeLayerB = CAShapeLayer()
    private var pulsatingLayer: CAShapeLayer!
    private var timer = Timer()
    private var statusTimer = Timer()
    //残り時間
    private var timeRemainingA:Float = 80
    private var timeRemainingB:Float = 300
    //スタート時点の残り時間
    private var timeStartA:Int = 80
    private var timeStartB:Int = 300
    var timerCounting: Bool = false
    
    var titleArray = ["A"]
    var timeArray = [80]
    var arrayCount = 0
    var finishTime: Int = 0
    
    var player: AVAudioPlayer?
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        taskTitle.text = "\(titleArray[arrayCount])"
        timeRemainingA = Float(timeArray[arrayCount])
        timeRemainingB = Float(timeArray.reduce(0, +))
        timeStartA = timeArray[arrayCount]
        timeStartB = timeArray.reduce(0, +)
        
        makeTimerLabel()
        
        self.synthesizer.delegate = self
        
        endTimeLabel.isHidden = true
    }
    
    private func setupView() {
        //タイトルの色
        taskTitle.textColor = .color4
        
        //ボタンの丸み
        startStopButton.layer.cornerRadius = 50
        minusButton.layer.cornerRadius = 25
        plusButton.layer.cornerRadius = 25
        //ボタンの背景色
        startStopButton.backgroundColor = .color3
        minusButton.backgroundColor = .color1
        plusButton.backgroundColor = .color1
        //ボタンの枠線
        self.minusButton.layer.borderWidth = 5.0    // 枠線の幅
        self.minusButton.layer.borderColor = UIColor.rgb(r: 0, g: 173, b: 181).cgColor    // 枠線の色
        self.plusButton.layer.borderWidth = 5.0    // 枠線の幅
        self.plusButton.layer.borderColor = UIColor.rgb(r: 234, g: 84, b: 85).cgColor    // 枠線の色
        //背景の色
        view.backgroundColor = .color1
        //ボタンのテキストの色
        minusButton.setTitleColor(UIColor.rgb(r: 0, g: 173, b: 181), for: .normal)
        plusButton.setTitleColor(UIColor.rgb(r: 234, g: 84, b: 85), for: .normal)
        //残り時間表示ラベル
        timerLabel.textAlignment = .center
        timerLabel.font = .boldSystemFont(ofSize: view.frame.width / 8)
        timerLabel.textColor = .color4
        timerLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        timerLabel.center = view.center
        
        endTimeLabel.font = .boldSystemFont(ofSize: view.frame.width / 20)
        
        setupCircleLayers()
        view.addSubview(timerLabel)
        view.addSubview(endTimeLabel)
        forNextBack()
        
        statusTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.forPlusMinus),
            userInfo: nil,
            repeats: true )
    }
    
    @objc func forPlusMinus(_ sender: Timer) {
        if (timeStartA-Int(timeRemainingA)) < 5 {
            plusButton.isEnabled = false
            print("プラスボタン無効")
        } else if Int(timeRemainingA) < 5 {
            minusButton.isEnabled = false
            print("マイナスボタン無効")
        } else {
            minusButton.isEnabled = true
            plusButton.isEnabled = true
        }
    }
    
    func alertSound() {
        if let soundURL = Bundle.main.url(forResource: "ポーン", withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.play()
            } catch {
                print("ポーンのエラー")
            }
        }
    }
    
    func buttonSound() {
        if let soundURL = Bundle.main.url(forResource: "ポカッ", withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.play()
            } catch {
                print("ポカッのエラー")
            }
        }
    }
    
    func speechTitle() {
        //しゃべる内容
        let utterance = AVSpeechUtterance(string: "\(titleArray[arrayCount])を始めてください。。。\(Int(Int(timeRemainingA) / 60))分\(Int(Int(timeRemainingA) % 60))秒です")
        //言語
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        //スピード
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        //声の高さ
        utterance.pitchMultiplier = 1.2
        
        synthesizer.speak(utterance)
    }
    
    func forNextBack() {
        if arrayCount == 0 {
            backButton.isEnabled = false
        } else if arrayCount == (titleArray.count)-1 {
            nextButton.isEnabled = false
        } else {
            backButton.isEnabled = true
            nextButton.isEnabled = true
        }
    }
    
    func makeTimerLabel() {
        let min = Int(Int(timeRemainingA) / 60)
        let sec = Int(Int(timeRemainingA) % 60)
        self.timerLabel.text = String(format: "%02d：%02d", min, sec)
    }
    
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
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayerA.add(basicAnimation, forKey: "urSoBasic")
        shapeLayerB.add(basicAnimation, forKey: "urSoBasic")
    }
    
    @IBAction func backButton(_ sender: Any) {
        arrayCount -= 1
        taskTitle.text = "\(titleArray[arrayCount])"
        timeRemainingA = Float(timeArray[arrayCount])
        if arrayCount > 0 {
            timeRemainingB = Float(timeArray.reduce(0, +))
            for i in 0...arrayCount-1 {
                timeRemainingB -= Float(timeArray[i])
            }
        }
        timeStartA = timeArray[arrayCount]
        makeTimerLabel()
        forNextBack()
        alertSound()
        speechTitle()
        //ボタンの振動
        Feedbacker.impact(style: .medium)
    }
    @IBAction func nextButton(_ sender: Any) {
        arrayCount += 1
        taskTitle.text = "\(titleArray[arrayCount])"
        timeRemainingA = Float(timeArray[arrayCount])
        timeRemainingB = Float(timeArray.reduce(0, +))
        for i in 0...arrayCount-1 {
            timeRemainingB -= Float(timeArray[i])
        }
        timeStartA = timeArray[arrayCount]
        makeTimerLabel()
        forNextBack()
        alertSound()
        speechTitle()
        //ボタンの振動
        Feedbacker.impact(style: .medium)
    }
    
    @IBAction func startStopButton(_ sender: UIButton) {
        if(timerCounting){
            timerCounting = false
            startStopButton.setTitle("START", for: .normal)
            startStopButton.backgroundColor = .color3
            //STOPボタンの役割
            buttonSound()
            timer.invalidate()
        } else {
            timerCounting = true
            startStopButton.setTitle("STOP", for: .normal)
            startStopButton.backgroundColor = UIColor.rgb(r: 234, g: 84, b: 85)
            //STARTボタンの役割
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.1,
                                         target: self,
                                         selector: #selector(TimerViewController.timerClass),
                                         userInfo: nil,
                                         repeats: true)
            alertSound()
            animateCircle()
        }
        
        // アプリ初期化時等
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback,
                                                            options: [AVAudioSession.CategoryOptions.duckOthers])
        } catch _ {
            NSLog("audio session set category failure")
        }
        // 音声、動画再生時
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
            NSLog("audio session active failure")
        }
        //ボタンの振動
        Feedbacker.impact(style: .medium)
    }
    
    @IBAction func minusButton(_ sender: Any) {
        timeRemainingA -= 5
        timeRemainingB -= 5
        //timerLabel.text = "残り \n\(Int(timeRemainingA))"
        makeTimerLabel()
        animateCircle()
        //ボタンの振動
        Feedbacker.impact(style: .medium)
        buttonSound()
        //animateCircle()
    }
    @IBAction func plusButton(_ sender: Any) {
        timeRemainingA += 5
        timeRemainingB += 5
        //timerLabel.text = "残り \n\(Int(timeRemainingA))"
        makeTimerLabel()
        animateCircle()
        //ボタンの振動
        Feedbacker.impact(style: .medium)
        buttonSound()
        //animateCircle()
    }
    
    @objc func timerClass() {
        if timeRemainingA > 0 {
            timeRemainingA -= 0.1
            timeRemainingB -= 0.1
        } else {
//            timer.invalidate()
//            timeRemainingA = 80
//            timeRemainingB = 300
            arrayCount += 1
            if arrayCount == titleArray.count {
                //全てのタイマーが終了した時の処理
                timer.invalidate()
            } else {
                taskTitle.text = "\(titleArray[arrayCount])"
                timeRemainingA = Float(timeArray[arrayCount])
                timeStartA = timeArray[arrayCount]
                makeTimerLabel()
                forNextBack()
                alertSound()
                speechTitle()
            }
        }
        let percentageA = CGFloat(1 - Float(timeRemainingA) * 1 / Float(timeStartA))
        let percentageB = CGFloat(1 - Float(timeRemainingB) * 1 / Float(timeStartB))
        self.shapeLayerA.strokeEnd = percentageA
        self.shapeLayerB.strokeEnd = percentageB
        makeTimerLabel()
        print("割合は\(percentageA)")
    }
}

