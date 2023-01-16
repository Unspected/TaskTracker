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
    
    //MARK: - variables
    var taskViewModel: TaskViewModel!
    
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
        
    }
    
    // MARK: - Outlets & obj functions
    @IBAction func startButtonPressed(_ sender: UIButton) {
        
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
            
        } else if (textField == minutesTextField) {
            
        } else {
            
        }
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //MARK: - functions
    
}

extension NewTaskViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLenth = 2
        let currentText: NSString = (textField.text ?? "" ) as NSString
        let newString: NSString = currentText.replacingCharacters(in: range, with: string) as NSString
        
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
        self.collectionView.reloadData()
    }
    
    
    
    
}
