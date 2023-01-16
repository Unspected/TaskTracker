//
//  TaskTypeCollectionViewCell.swift
//  TaskTracker
//
//  Created by Pavel Andreev on 1/15/23.
//
import UIKit

class TaskTypeCollectionViewCell: UICollectionViewCell {
    
    //MARK:- outlets

    @IBOutlet weak var imageContainerView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var typeName: UILabel!
    
    //MARK:- variables
    
    let cellNibID = UINib(nibName: "cell", bundle: .main)
    //MARK:- lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        DispatchQueue.main.async {
            self.imageContainerView.layer.cornerRadius = self.imageContainerView.bounds.width / 2
        }
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
        
    }
    
    //MARK:- functions
    override class func description() -> String {
        return "taskTypeCollectionView"
    }
    
    func setupCell(taskType: TaskType, isSelected: Bool) {
        typeName.text = taskType.typeName
        if (isSelected) {
            imageContainerView.backgroundColor = UIColor(hex: "17b890").withAlphaComponent(0.5)
            typeName.textColor = UIColor(hex: "006666")
            imageView.tintColor = UIColor.white
            imageView.image = UIImage(systemName: taskType.symbolName,
                                           withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium))
        } else {
            imageView.image = UIImage(systemName: taskType.symbolName,
                                           withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
            reset()
        }
    }
    
    func reset() {
        imageContainerView.backgroundColor = UIColor.clear
        typeName.textColor = UIColor.black
        imageView.tintColor = UIColor.black
    }

}
