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
        let strokeEnd = CABasicAnimation(keyPath: "StrokeEnd")
        strokeEnd.toValue = 0
        strokeEnd.fillMode = .forwards
        strokeEnd.isRemovedOnCompletion = true
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.setupLayers()
        }
    }
    
    
    // MARK: - Outlets & Objc function
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
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
}
