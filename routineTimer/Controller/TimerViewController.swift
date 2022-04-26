import UIKit
import AVFoundation

class TimerViewController: UIViewController, AVSpeechSynthesizerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var comingTaskTitle: UILabel!
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
    private var player: AVAudioPlayer?
    private let synthesizer = AVSpeechSynthesizer()
    
    private let playIcon = UIImage(named: "playTimer")
    private let stopIcon = UIImage(named: "stopTimer")
    private let state = UIControl.State.normal
    
    private var arrayCount = 0
    var titleArray = ["A"]
    var timeArray = [80]
    //残り時間
    private var timeRemainingA: Float = 80
    private var timeRemainingB: Float = 300
    //スタート時点の残り時間
    private var totalTimeA = 80
    private var totalTimeB = 300
    private var timerCounting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
    }
    
    private func setupView() {
        taskTitle.text = "\(titleArray[arrayCount])"
        if arrayCount != titleArray.count-1 {
            comingTaskTitle.text = "次のタスク：\(titleArray[arrayCount+1])"
        } else {
            comingTaskTitle.text = "これが最後のタスクです"
        }
        timeRemainingA = Float(timeArray[arrayCount])
        timeRemainingB = Float(timeArray.reduce(0, +))
        totalTimeA = timeArray[arrayCount]
        totalTimeB = timeArray.reduce(0, +)
        
        makeTimerLabel()
        
        self.synthesizer.delegate = self
        navigationController?.delegate = self
        
        //タイトルの色
        taskTitle.textColor = .white
        comingTaskTitle.textColor = .systemGray4
        
        //ボタンの丸み
        startStopButton.layer.cornerRadius = 40
        minusButton.layer.cornerRadius = 25
        plusButton.layer.cornerRadius = 25
        //ボタンの背景色
        startStopButton.backgroundColor = .clear
        minusButton.backgroundColor = .clear
        plusButton.backgroundColor = .clear
        //背景の色
        view.backgroundColor = .customeBlack
        //残り時間表示ラベル
        timerLabel.textAlignment = .center
        timerLabel.font = .boldSystemFont(ofSize: view.frame.width / 8)
        timerLabel.font = UIFont(name:"Helvetica Light", size: view.frame.width / 8)
        timerLabel.textColor = .white
        timerLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        timerLabel.center = view.center
        
        setupCircleLayers()
        view.addSubview(timerLabel)
    }
    
    private func setupCircleLayers() {
        
        pulsatingLayer = createCircleShapeLayerA(strokeColor: .customeGray, fillColor: .customeGray)
        view.layer.addSublayer(pulsatingLayer)
        //animatePulsatingLayer()
        
        let trackLayerA = createCircleShapeLayerA(strokeColor: .customeGray, fillColor: .customeBlack)
        view.layer.addSublayer(trackLayerA)
        let trackLayerB = createCircleShapeLayerB(strokeColor: .customeGray, fillColor: .customeBlack)
        view.layer.addSublayer(trackLayerB)
        
        shapeLayerA = createCircleShapeLayerA(strokeColor: .customeBlue, fillColor: .clearColor)
        shapeLayerA.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayerA.strokeEnd = 0
        
        shapeLayerB = createCircleShapeLayerB(strokeColor: .customeOrange, fillColor: .clearColor)
        shapeLayerB.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayerB.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayerA)
        view.layer.addSublayer(shapeLayerB)
    }
    
    private func makeTimerLabel() {
        let min = Int(Int(timeRemainingA) / 60)
        let sec = Int(Int(timeRemainingA) % 60)
        self.timerLabel.text = String(format: "%02d：%02d", min, sec)
    }
    
    private func createCircleShapeLayerA(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: view.frame.width / 2.5, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 15
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = view.center
        return layer
    }
    
    private func createCircleShapeLayerB(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: (view.frame.width / 2.5) - 13, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 5
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = view.center
        return layer
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.2
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
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
    
    private func forPlusMinus() {
        minusButton.isEnabled = !(totalTimeA-Int(timeRemainingA) < 10)
        plusButton.isEnabled = !(Int(timeRemainingA) < 10)
    }
    
    private func playSound(forResource: String) {
        if let soundURL = Bundle.main.url(forResource: forResource, withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.play()
            } catch {
                print("\(forResource)のエラー")
            }
        }
    }
    
    private func speechTitle() {
        //1秒後の処理
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            synthesizer.stopSpeaking(at: .immediate)
            if (timeArray[arrayCount] / 60) >= 1 && (timeArray[arrayCount] % 60) != 0 {
                readTitle(message: "\(titleArray[arrayCount])を始めてください。。。\(timeArray[arrayCount] / 60))ふん\(timeArray[arrayCount] % 60))秒です")
            } else if (timeArray[arrayCount] / 60) < 1 && (timeArray[arrayCount] % 60) != 0 {
                readTitle(message: "\(titleArray[arrayCount])を始めてください。。。\(timeArray[arrayCount] % 60))秒です")
            } else if (timeArray[arrayCount] / 60) >= 1 && (timeArray[arrayCount] % 60) == 0 {
                readTitle(message: "\(titleArray[arrayCount])を始めてください。。。\(timeArray[arrayCount] / 60))ふんです")
            }
        }
    }
    
    private func readTitle(message: String) {
        let nowCount = arrayCount
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.pitchMultiplier = 1.2
        if nowCount == arrayCount {
            self.synthesizer.speak(utterance)
        }
    }
    
    private func speechFinish() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            readTitle(message: "お疲れ様でした")
        }
    }
    
    private func timerAdjuster(isPlus: Bool) {
        plusButton.isEnabled = true
        if isPlus {
            timeRemainingA += 5
            timeRemainingB += 5
        } else {
            timeRemainingA -= 5
            timeRemainingB -= 5
        }
        makeTimerLabel()
        animateCircle()
        Feedbacker.impact(style: .medium)
        playSound(forResource: "ポカッ")
        let percentageA = CGFloat(1 - Float(timeRemainingA) * 1 / Float(totalTimeA))
        let percentageB = CGFloat(1 - Float(timeRemainingB) * 1 / Float(totalTimeB))
        self.shapeLayerA.strokeEnd = percentageA
        self.shapeLayerB.strokeEnd = percentageB
    }
    
    @IBAction func nextButton(_ sender: Any) {
        Feedbacker.impact(style: .medium)
        synthesizer.stopSpeaking(at: .immediate)
        if arrayCount != (titleArray.count)-1 {
            arrayCount += 1
            if arrayCount != (titleArray.count)-1 {
                comingTaskTitle.text = "次のタスク：\(titleArray[arrayCount+1])"
            } else {
                comingTaskTitle.text = "最後のタスクです"
            }
        } else {
            playSound(forResource: "カコ")
            return
        }
        taskTitle.text = "\(titleArray[arrayCount])"
        timeRemainingA = Float(timeArray[arrayCount])
        timeRemainingB = Float(timeArray.reduce(0, +))
        for i in 0...arrayCount-1 {
            timeRemainingA = Float(timeArray[arrayCount])
            timeRemainingB -= Float(timeArray[i])
        }
        totalTimeA = timeArray[arrayCount]
        makeTimerLabel()
        if timer.isValid == true {
            playSound(forResource: "ポーン")
            speechTitle()
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        Feedbacker.impact(style: .medium)
        synthesizer.stopSpeaking(at: .immediate)
        if arrayCount > 0 {
            arrayCount -= 1
        } else {
            self.playSound(forResource: "カコ")
            return
        }
        taskTitle.text = "\(titleArray[arrayCount])"
        timeRemainingA = Float(timeArray[arrayCount])
        timeRemainingB = Float(timeArray.reduce(0, +))
        if arrayCount != 0 {
            for i in 0...arrayCount-1 {
                timeRemainingA = Float(timeArray[arrayCount])
                timeRemainingB -= Float(timeArray[i])
            }
        } else if arrayCount == 0 {
            timeRemainingA = Float(timeArray[arrayCount])
            timeRemainingB = Float(timeArray.reduce(0, +))
        }
        comingTaskTitle.text = "次のタスク：\(titleArray[arrayCount+1])"
        totalTimeA = timeArray[arrayCount]
        makeTimerLabel()
        if timer.isValid == true {
            playSound(forResource: "ポーン")
            speechTitle()
        }
    }
    
    @IBAction func startStopButton(_ sender: UIButton) {
        Feedbacker.impact(style: .medium)
        timer.invalidate()
        if timerCounting {
            startStopButton.setImage(playIcon, for: state)
            //STOPボタンの役割
            playSound(forResource: "ポカッ")
            synthesizer.stopSpeaking(at: .immediate)
        } else {
            startStopButton.setImage(stopIcon, for: state)
            //STARTボタンの役割
            timer = Timer.scheduledTimer(timeInterval: 0.1,
                                         target: self,
                                         selector: #selector(TimerViewController.timerClass),
                                         userInfo: nil,
                                         repeats: true)
            playSound(forResource: "ポーン")
            if arrayCount == 0 && Int(timeRemainingA) == timeArray[0] {
                speechTitle()
            }
            animateCircle()
        }
        timerCounting.toggle()
        // アプリ初期化時等
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.duckOthers])
        } catch _ {
            NSLog("audio session set category failure")
        }
        // 音声、動画再生時
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
            NSLog("audio session active failure")
        }
    }
    
    @IBAction func minusButton(_ sender: Any) {
        if Int(timeRemainingA) < 6 {
            playSound(forResource: "カコ")
            return
        }
        timerAdjuster(isPlus: false)
    }
    
    @IBAction func plusButton(_ sender: Any) {
        if totalTimeA-Int(timeRemainingA) < 6 {
            playSound(forResource: "カコ")
            return
        }
        timerAdjuster(isPlus: true)
    }
    
    @objc func timerClass() {
        if timeRemainingA > 0 {
            timeRemainingA -= 0.1
            timeRemainingB -= 0.1
        } else {
            arrayCount += 1
            if arrayCount == titleArray.count {
                //全てのタイマーが終了した時の処理
                timer.invalidate()
                playSound(forResource: "キラーん")
                speechFinish()
                //let finishVC = self.storyboard?.instantiateViewController(withIdentifier: "FinishView") as! FinishViewController
                let storyboard = UIStoryboard(name: "Finish", bundle: nil)
                let finishVC = storyboard.instantiateViewController(withIdentifier: "FinishView") as! FinishViewController
                finishVC.modalPresentationStyle = .overCurrentContext
                finishVC.modalTransitionStyle = .crossDissolve
                self.present(finishVC, animated: true)
                return
            } else {
                //次のタスクに切り替わった時
                taskTitle.text = "\(titleArray[arrayCount])"
                if arrayCount != (titleArray.count)-1 {
                    comingTaskTitle.text = "次のタスク：\(titleArray[arrayCount+1])"
                } else {
                    comingTaskTitle.text = "最後のタスクです"
                }
                timeRemainingA = Float(timeArray[arrayCount])
                totalTimeA = timeArray[arrayCount]
                makeTimerLabel()
                synthesizer.stopSpeaking(at: .immediate)
                playSound(forResource: "ポーン")
                speechTitle()
            }
        }
        
        let percentageA = CGFloat(1 - Float(timeRemainingA) * 1 / Float(totalTimeA))
        let percentageB = CGFloat(1 - Float(timeRemainingB) * 1 / Float(totalTimeB))
        self.shapeLayerA.strokeEnd = percentageA
        self.shapeLayerB.strokeEnd = percentageB
        makeTimerLabel()
        print("割合は\(percentageA)")
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        timer.invalidate()
        synthesizer.stopSpeaking(at: .immediate)
        self.navigationController?.popViewController(animated: true)
    }
}

