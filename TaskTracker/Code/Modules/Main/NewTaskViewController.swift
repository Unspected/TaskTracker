//
//  NewTaskViewController.swift
//  TaskTracker
//
//  Created by Pavel Andreev on 1/13/23.
//

import UIKit

class NewTaskViewController: UIViewController {
    
    //MARK:- outlets
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    
    @IBOutlet weak var nameDescriptionContainerView: UIView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK:- variables
    var taskViewModel: TaskViewModel!
    
    
    
    
    // MARK:-  lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskViewModel = TaskViewModel()
        
        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
//        self.collectionView.register(UINib(nibName: TaskTypeCollectionViewCell.description(),
//                                           bundle: .main),
//                                     forCellWithReuseIdentifier: TaskTypeCollectionViewCell.description())
                
    }
    
    // MARK:- Outlets & obj functions
    @IBAction func startButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func multiplayButtonPressed(_ sender: UIButton) {
        
    }
    
    //MARK:- functions
    
}


extension NewTaskViewController: UICollectionViewDelegateFlowLayout {
   
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
    
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskTypeCollectionViewCell.description(), for: indexPath) as! TaskTypeCollectionViewCell
        
//        cell.setupCell(taskType: self.taskViewModel.getTaskTypes()[indexPath.item],
//                       isSelected: taskViewModel.getSelectedIndex() == indexPath.item)
//        return cell
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.taskViewModel.setSelectedIndex(to: indexPath.item)
    }
    
    
}
