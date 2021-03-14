//
//  PlanViewCellTableViewCell.swift
//  studyplanet
//
//  Created by Jordan on 30/12/2020.
//

import UIKit


class PlanTableViewCell: UITableViewCell {
    
    
    //@IBOutlet weak var completedBtn: UIButton!
    
    @IBOutlet weak var tickBtn: UIButton!
    
    var indexPathForCell: IndexPath?

    static let identifier = "PlanTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "PlanTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var backgroundCell: UIView!
    
    @IBAction func planDoneBtn(_ sender: UIButton) {
    }
    
    var completed = false
    let deselectImage = UIImage(named: "checkmark.circle")
    let selectImage = UIImage(named: "checkmark.circle.fill")
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moduleLabel: UILabel!
    
    @IBAction func clickedBtn(_ sender: UIButton) {

        if(!sender.isSelected){
            PlanVC.sessionCompleted(indexPath: indexPathForCell!)
            sender.isSelected.toggle()
        }
    }
    
    

    public func configure(with title:String, time:Int, indexPath: IndexPath){
        moduleLabel.text = title
        timeLabel.text = String(time) + ":00"
        
        //show tick buttons selected or not
        if(PlanVC.daySelected == "monday"){
            if (PlanVC.mondayCompleted[indexPath.row] == true){ // if it is selected
                if(!tickBtn.isSelected){ // if not selected
                    tickBtn.isSelected.toggle() // select
                }
            } else { // if is not selected
                if(tickBtn.isSelected){ // if it is selected
                    tickBtn.isSelected.toggle() // deselected
                }
            }
        }
        if(PlanVC.daySelected == "tuesday"){
            if (PlanVC.tuesdayCompleted[indexPath.row] == true){ // if it is selected
                if(!tickBtn.isSelected){ // if not selected
                    tickBtn.isSelected.toggle() // select
                }
            } else { // if is not selected
                if(tickBtn.isSelected){ // if it is selected
                    tickBtn.isSelected.toggle() // deselected
                }
            }
        }
        if(PlanVC.daySelected == "wednesday"){
            if (PlanVC.wednesdayCompleted[indexPath.row] == true){ // if it is selected
                if(!tickBtn.isSelected){ // if not selected
                    tickBtn.isSelected.toggle() // select
                }
            } else { // if is not selected
                if(tickBtn.isSelected){ // if it is selected
                    tickBtn.isSelected.toggle() // deselected
                }
            }
        }
        if(PlanVC.daySelected == "thursday"){
            if (PlanVC.thursdayCompleted[indexPath.row] == true){ // if it is selected
                if(!tickBtn.isSelected){ // if not selected
                    tickBtn.isSelected.toggle() // select
                }
            } else { // if is not selected
                if(tickBtn.isSelected){ // if it is selected
                    tickBtn.isSelected.toggle() // deselected
                }
            }
        }
        if(PlanVC.daySelected == "friday"){
            if (PlanVC.fridayCompleted[indexPath.row] == true){ // if it is selected
                if(!tickBtn.isSelected){ // if not selected
                    tickBtn.isSelected.toggle() // select
                }
            } else { // if is not selected
                if(tickBtn.isSelected){ // if it is selected
                    tickBtn.isSelected.toggle() // deselected
                }
            }
        }
        if(PlanVC.daySelected == "saturday"){
            if (PlanVC.saturdayCompleted[indexPath.row] == true){ // if it is selected
                if(!tickBtn.isSelected){ // if not selected
                    tickBtn.isSelected.toggle() // select
                }
            } else { // if is not selected
                if(tickBtn.isSelected){ // if it is selected
                    tickBtn.isSelected.toggle() // deselected
                }
            }
        }
        if(PlanVC.daySelected == "sunday"){
            if (PlanVC.sundayCompleted[indexPath.row] == true){ // if it is selected
                if(!tickBtn.isSelected){ // if not selected
                    tickBtn.isSelected.toggle() // select
                }
            } else { // if is not selected
                if(tickBtn.isSelected){ // if it is selected
                    tickBtn.isSelected.toggle() // deselected
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundCell.layer.cornerRadius = backgroundCell.frame.height / 2.3
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
