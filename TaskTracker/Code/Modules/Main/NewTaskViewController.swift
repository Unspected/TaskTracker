//
//  NewTaskViewController.swift
//  TaskTracker
//
//  Created by Pavel Andreev on 1/13/23.
//

import UIKit

class NewTaskViewController: UIViewController {
    
    //MARK: - outlets
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    
    @IBOutlet weak var nameDescriptionContainerView: UIView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var newTaskTopConstraint: NSLayoutConstraint!
    //MARK: - variables
    private var taskViewModel: TaskViewModel!
    private var keyboardOpened = false
    
    // MARK: -  lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        taskViewModel = TaskViewModel()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "TaskTypeCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: TaskTypeCollectionViewCell.description())
        
        startButton.layer.cornerRadius = 12
        nameDescriptionContainerView.layer.cornerRadius = 12
        
        [self.hourTextField, self.minutesTextField, self.secondTextField].forEach {
            $0?.attributedPlaceholder = NSAttributedString(string: "00",
                                                           attributes: [NSAttributedString.Key.font: UIFont(name: "Code-Pro-Bold-LC", size: 55)!,
                                                           NSAttributedString.Key.foregroundColor: UIColor.black])
            $0?.delegate = self
            $0?.addTarget(self, action: #selector(textFieldInputChanged(_:)), for: .editingChanged)
        }
        
        taskNameTextField.attributedPlaceholder = NSAttributedString(string: "Task Name",
                                                                     attributes: [NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 16)!,
                                                                    NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.55)])
        
        taskNameTextField.addTarget(self, action: #selector(textFieldInputChanged(_:)), for: .editingChanged)
        
        taskDescriptionTextField.attributedPlaceholder = NSAttributedString(string: "Short Description",
                                                                            attributes: [NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 16)!,
                                                                           NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.55)])
        taskDescriptionTextField.addTarget(self, action: #selector(textFieldInputChanged(_:)), for: .editingChanged)
        
        self.disableButton()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        taskViewModel.getHours().bind { hours in
            self.hourTextField.text = hours.appendZeroes()
        }
        
        taskViewModel.getMinutes().bind { minutes in
            self.minutesTextField.text = minutes.appendZeroes()
        }
        
        taskViewModel.getSeconds().bind { seconds in
            self.secondTextField.text = seconds.appendZeroes()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    }
    
    // MARK: - Outlets & obj functions
    @IBAction func startButtonPressed(_ sender: UIButton) {
        guard let timerVC = self.storyboard?.instantiateViewController(withIdentifier: TimerViewController.description()) as? TimerViewController else { return }
        taskViewModel.computeSeconds()
        self.present(timerVC, animated: true)
    }
    
    @IBAction func multiplayButtonPressed(_ sender: UIButton) {
        
    }
    
    @objc func textFieldInputChanged(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        
        if (textField == taskNameTextField) {
            
            taskViewModel.setTaskName(to: text)
            
        } else if (textField == taskDescriptionTextField) {
            
            taskViewModel.setTaskDescription(to: text)
            
        } else if (textField == hourTextField) {
            
            guard let hours = Int(text) else { return }
            taskViewModel.setHours(to: hours)
            
        } else if (textField == minutesTextField) {
            
            guard let minutes = Int(text) else { return }
            taskViewModel.setMinutes(to: minutes)
        } else {
            guard let seconds = Int(text) else { return }
            taskViewModel.setSeconds(to: seconds)
        }
        checkButtonStatus()
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if !Constants.hasToNotch, !keyboardOpened {
            keyboardOpened.toggle()
            newTaskTopConstraint.constant -= self.view.frame.height * 0.2
            view.layoutIfNeeded()
        }
    }
    
    @objc func keyBoardWillHide(_ notifcation: Notification) {
        keyboardOpened = false
        newTaskTopConstraint.constant = 20
    }
    
    //MARK: - functions
    override class func description() -> String {
        return "NewTaskViewController"
    }
    
    func enableButton() {
        if startButton.isUserInteractionEnabled == false {
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                self.startButton.layer.opacity = 1
            } completion: { _ in
                self.startButton.isUserInteractionEnabled.toggle()
            }
        }
    }
    
    func disableButton() {
        if startButton.isUserInteractionEnabled {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                self.startButton.layer.opacity = 0.25
            } completion: { _ in
                self.startButton.isUserInteractionEnabled.toggle()
            }
        }
    }
    
    func checkButtonStatus() {
        if taskViewModel.isTaskValid() {
            // enable button
            enableButton()
        } else {
            // disable button
            disableButton()
        }
    }
    
}

extension NewTaskViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLenth = 2
        let currentText: NSString = (textField.text ?? "" ) as NSString
        let newString: NSString = currentText.replacingCharacters(in: range, with: string) as NSString
        
        guard let text = textField.text else { return false }
        
        if (text.count == 2 && text.starts(with: "0")) {
            textField.text?.removeFirst()
            textField.text? += string
            self.textFieldInputChanged(textField)
        }
        
        return newString.length <= maxLenth
    }
}



extension NewTaskViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.taskViewModel.getTaskTypes().count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3.75
        let width: CGFloat = collectionView.frame.width
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let adjustedWidth = width - (flowLayout.minimumLineSpacing * (columns - 1))
        
        return CGSize(width: adjustedWidth / columns, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskTypeCollectionViewCell.description(), for: indexPath) as! TaskTypeCollectionViewCell
        cell.setupCell(taskType: self.taskViewModel.getTaskTypes()[indexPath.item], isSelected: taskViewModel.getSelectedIndex() == indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.taskViewModel.setSelectedIndex(to: indexPath.item)
        self.collectionView.reloadSections(IndexSet(0..<1))
        checkButtonStatus()
    }
    
}
