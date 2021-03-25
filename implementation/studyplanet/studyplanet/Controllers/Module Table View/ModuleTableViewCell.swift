//
//  ModuleTableViewCell.swift
//  moduletableproject
//
//  Created by Jordan on 23/12/2020.
//

import UIKit

class ModuleTableViewCell: UITableViewCell {
    // delegate
    var delegate: ModuleViewController!
    
    
    // declare outlets
    @IBOutlet var moduleLabel: UILabel!
    @IBOutlet var moduleSlider: UISlider!
    @IBOutlet weak var badBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var goodBtn: UIButton!

    // users data
    var currentConfidence : Int!
    var defaultConfidence = 66
    
    // identifier
    static let identifier = "ModuleTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "ModuleTableViewCell", bundle: nil)
    }
    
    // set up the cell
    public func configure(with title:String){
        moduleLabel.text = title
        let confidence = currentConfidence ?? defaultConfidence

        if(confidence == 33){
            goodBtn.isSelected = true
            badBtn.isSelected = false
            okBtn.isSelected = false
        } else if(confidence == 99){
            badBtn.isSelected = true
            okBtn.isSelected = false
            goodBtn.isSelected = false
        } else { // if no value
            okBtn.isSelected = true
            goodBtn.isSelected = false
            badBtn.isSelected = false
        }
        
    }

    
    
    //  *********************   button  and  actions  *********************
    
    @IBAction func badBtnClicked(_ sender: UIButton) { // not confident in module
        let module = moduleLabel.text
        let difficulty = 99
        
        currentConfidence = difficulty
        delegate?.changeConfidence(module: module!, confidence: difficulty)
       
        badBtn.isSelected.toggle()

        if(badBtn.isSelected){
            if(okBtn.isSelected){
                okBtn.isSelected.toggle()
            }
            if(goodBtn.isSelected){
                goodBtn.isSelected.toggle()
            }
        }
        
        if(!goodBtn.isSelected && !okBtn.isSelected && !badBtn.isSelected){
            badBtn.isSelected.toggle()
        }
    }
    
    @IBAction func okBtnClicked(_ sender: UIButton) { // ok confidence in module
        let module = moduleLabel.text
        let difficulty = 66
        
        currentConfidence = difficulty

        delegate?.changeConfidence(module: module!, confidence: difficulty)
        okBtn.isSelected.toggle()
        
        if(okBtn.isSelected){
            if(badBtn.isSelected){
                badBtn.isSelected.toggle()
            }
            if(goodBtn.isSelected){
                goodBtn.isSelected.toggle()
            }
        }
        
        if(!goodBtn.isSelected && !okBtn.isSelected && !badBtn.isSelected){
            okBtn.isSelected.toggle()
        }
        
    }
    
    @IBAction func goodBtnClicked(_ sender: UIButton) { // confident in module
        let module = moduleLabel.text
        let difficulty = 33
        
        currentConfidence = difficulty

        delegate?.changeConfidence(module: module!, confidence: difficulty)
        goodBtn.isSelected.toggle()
        
        if(goodBtn.isSelected){
            if(okBtn.isSelected){
                okBtn.isSelected.toggle()
            }
            if(badBtn.isSelected){
                badBtn.isSelected.toggle()
            }
        }
        
        if(!goodBtn.isSelected && !okBtn.isSelected && !badBtn.isSelected){
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if(currentConfidence == 33){
            goodBtn.isSelected = true
            badBtn.isSelected = false
            okBtn.isSelected = false
        } else if(currentConfidence == 99){
            badBtn.isSelected = true
            okBtn.isSelected = false
            goodBtn.isSelected = false
        } else { // if no value
            okBtn.isSelected = true
            goodBtn.isSelected = false
            badBtn.isSelected = false
        }
        
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
