//
//  TimerViewController.swift
//  TaskTracker
//
//  Created by Pavel Andreev on 1/16/23.
//

import UIKit

class TimerViewController: UIViewController {
    
    //MARK: - IBOoutlets
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerContainerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var pauseResumeView: UIView!
    @IBOutlet weak var resetView: UIView!
    
    @IBOutlet weak var pauseResumeButton: UIButton!
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: - Variables
    var taskViewModel: TaskViewModel!
    
    var timerSeconds = 0
    
    var totalSeconds = 0 {
        didSet {
            timerSeconds = totalSeconds
        }
    }
    
    let timerAttributes = [NSAttributedString.Key.font: UIFont(name: "Code-Pro-Bold-LC", size: 46)!, .foregroundColor: UIColor.black]
    let semiBoldAttributes = [NSAttributedString.Key.font: UIFont(name: "Code-Pro-LC", size: 32)!, .foregroundColor: UIColor.black]
    
    let timerTrackLayer = CAShapeLayer()
    let timerCircleFillLayer = CAShapeLayer()
    
    var timerState: CountDownState = .suspended
    var countDownTimer = Timer()
    
    lazy var timerEndAnimation: CABasicAnimation = {
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.toValue = 0
        strokeEnd.fillMode = .forwards
        strokeEnd.isRemovedOnCompletion = true
        return strokeEnd
    }()
    
    lazy var timerResetAnimation: CABasicAnimation = {
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.toValue = 1
        strokeEnd.duration = 1
        strokeEnd.fillMode = .forwards
        strokeEnd.isRemovedOnCompletion = false
        return strokeEnd
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let task = taskViewModel.getTask()
        self.totalSeconds = task.seconds
        self.taskTitleLabel.text = task.taskName
        self.descriptionLabel.text = task.taskDescription
        self.imageContainerView.layer.cornerRadius = self.imageContainerView.frame.width / 2
        self.imageView.layer.cornerRadius = self.imageView.frame.width / 2
        self.imageView.image = UIImage(systemName: task.taskType.symbolName)
        
        [pauseResumeView, resetView].forEach {
            guard let view = $0 else { return }
            view.layer.opacity = 0
            view.isUserInteractionEnabled = false
        }
        
        [playView, pauseResumeView, resetView].forEach { $0?.layer.cornerRadius = 17}
        
        timerView.transform = timerView.transform.rotated(by: 270.degreeToRadiance())
        timerLabel.transform = timerLabel.transform.rotated(by: 90.degreeToRadiance())
        timerContainerView.transform = timerContainerView.transform.rotated(by: 90.degreeToRadiance())
        
        updateLabels()
        addCircles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.setupLayers()
        }
    }
    
    
    // MARK: - Outlets & Objc function
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.timerTrackLayer.removeFromSuperlayer()
        self.timerCircleFillLayer.removeFromSuperlayer()
        countDownTimer.invalidate()
        self.dismiss(animated: true)
    }
    
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        guard timerState == .suspended else { return }
        self.timerEndAnimation.duration = Double(timerSeconds)
        animatePauseButton(symbolName: "pause.fill")
        animatePlayPauseResetViews(timerPlaying: false)
        startTimer()
    }
    
    
    @IBAction func pauseResumeButtonPressed(_ sender: UIButton) {
        switch timerState {
            case .running:
                self.timerState = .paused
                self.timerCircleFillLayer.strokeEnd = CGFloat(timerSeconds) / CGFloat(totalSeconds)
                self.resetTimer()
                animatePauseButton(symbolName: "play.fill")
            case .paused:
                self.timerState = .running
                self.timerEndAnimation.duration = Double(self.timerSeconds) + 1
                self.startTimer()
                
                animatePauseButton(symbolName: "pause.fill")
             
            default: break
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        self.timerState = .suspended
        self.timerSeconds = self.totalSeconds
        resetTimer()
        
        self.timerCircleFillLayer.add(timerResetAnimation, forKey: "reset")
        animatePauseButton(symbolName: "play.fill")
        animatePlayPauseResetViews(timerPlaying: true)
    }
    

    
    
    //MARK: - functions
    override class func description() -> String {
        return "TimerViewController"
    }
    
    func setupLayers() {
        let radius = self.timerView.frame.width < self.timerView.frame.height ? self.timerView.frame.width / 2 : self.timerView.frame.height / 2
        let arcPath = UIBezierPath(
                                   arcCenter: CGPoint(x: timerView.frame.height / 2, y: timerView.frame.width / 2),
                                   radius: radius,
                                   startAngle: 0,
                                   endAngle: 360.degreeToRadiance(),
                                   clockwise: true)
        self.timerTrackLayer.path = arcPath.cgPath
        self.timerTrackLayer.strokeColor = UIColor(hex: "F2A841").cgColor
        self.timerTrackLayer.lineWidth = 20
        self.timerTrackLayer.fillColor = UIColor.clear.cgColor
        self.timerTrackLayer.lineCap = .round
        
        self.timerCircleFillLayer.path = arcPath.cgPath
        self.timerCircleFillLayer.strokeColor = UIColor.black.cgColor
        self.timerCircleFillLayer.lineWidth = 21
        self.timerCircleFillLayer.fillColor = UIColor.clear.cgColor
        self.timerCircleFillLayer.lineCap = .round
        self.timerCircleFillLayer.strokeEnd = 1
        
        self.timerView.layer.addSublayer(timerTrackLayer)
        self.timerView.layer.addSublayer(timerCircleFillLayer)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.timerContainerView.layer.cornerRadius = self.timerContainerView.frame.width / 2
        }
    }
    
    func startTimer() {
        //update label functions
        updateLabels()
        
        countDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timerSeconds -= 1
            self.updateLabels()
            if (self.timerSeconds == 0) {
                timer.invalidate()
                self.resetButtonPressed(self)
                self.timerState = .suspended
                self.animatePlayPauseResetViews(timerPlaying: true)
                self.timerSeconds = self.totalSeconds
                self.resetTimer()
            }
        }
        self.timerState = .running
        self.timerCircleFillLayer.add(self.timerEndAnimation, forKey: "timerEnd")
    }
    
    func updateLabels() {
         let seconds = timerSeconds % 60
         let minutes = timerSeconds / 60 % 60
         let hours = timerSeconds / 3600
        
        if hours > 0 {
            let hoursCount = String(hours).count
            let minutesCount = String(minutes).count
            let secondsCount = String(seconds).count
            
            let timerString = "\(hours)h  \(minutes)m  \(seconds.appendZeroes())s"
            let attributedString = NSMutableAttributedString(string: timerString, attributes: semiBoldAttributes)
            
            attributedString.addAttributes(timerAttributes, range: NSRange(location: 0, length: hoursCount))
            attributedString.addAttributes(timerAttributes, range: NSRange(location: hoursCount + 2, length: minutesCount))
            attributedString.addAttributes(timerAttributes, range: NSRange(location: hoursCount + 2 + minutesCount + 3, length: secondsCount))
            
            self.timerLabel.attributedText = attributedString
            
        } else {
            let minutesCount = String(minutes).count
            let secondsCount = String(seconds.appendZeroes()).count
            
            let timerString = "\(minutes)m  \(seconds.appendZeroes())s"
            let attributedString = NSMutableAttributedString(string: timerString, attributes: semiBoldAttributes)
            
            attributedString.addAttributes(timerAttributes, range: NSRange(location: 0, length: minutesCount))
            attributedString.addAttributes(timerAttributes, range: NSRange(location: minutesCount + 3, length: secondsCount))
            
            self.timerLabel.attributedText = attributedString
        }
    }
    
    func resetTimer() {
        self.countDownTimer.invalidate()
        self.timerCircleFillLayer.removeAllAnimations()
        self.updateLabels()
    }
    
    func animatePauseButton(symbolName: String) {
        UIView.transition(with: pauseResumeButton, duration: 0.3, options: .transitionCrossDissolve) {
            self.pauseResumeButton.setImage(UIImage(systemName: symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold, scale: .default)), for: .normal)
        }
    }
    
    func animatePlayPauseResetViews(timerPlaying: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0,options: .curveEaseOut) {
            self.playView.layer.opacity = timerPlaying ? 1 : 0
            self.pauseResumeView.layer.opacity = timerPlaying ? 0 : 1
            self.resetView.layer.opacity = timerPlaying ? 0 : 1
        } completion: { [weak self] _ in
            [self?.pauseResumeView, self?.resetView].forEach {
                guard let view = $0 else { return }
                view.isUserInteractionEnabled = timerPlaying ? false : true
            }
        }
    }
    
    func addCircles() {
        let circle = CAShapeLayer()
        circle.path = UIBezierPath(arcCenter: CGPoint(x: 0, y: self.view.frame.height - 140),
                                   radius: 120,
                                   startAngle: 0,
                                   endAngle: 360.degreeToRadiance(),
                                   clockwise: true).cgPath
        circle.fillColor = UIColor(hex: "F6A63A").cgColor
        circle.opacity = 0.15
        
        let circleTwo = CAShapeLayer()
        circleTwo.path = UIBezierPath(arcCenter: CGPoint(x: 80, y: self.view.frame.height - 60),
                                   radius: 110,
                                   startAngle: 0,
                                   endAngle: 360.degreeToRadiance(),
                                   clockwise: true).cgPath
        circleTwo.fillColor = UIColor(hex: "F6A63A").cgColor
        circleTwo.opacity = 0.35
        
        self.view.layer.insertSublayer(circle, above: self.view.layer)
        self.view.layer.insertSublayer(circleTwo, above: self.view.layer)
        
        self.view.bringSubviewToFront(descriptionLabel)
    }
    
    
}
