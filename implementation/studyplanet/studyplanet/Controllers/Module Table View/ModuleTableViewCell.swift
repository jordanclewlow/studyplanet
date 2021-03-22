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

    
    // identifier
    static let identifier = "ModuleTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "ModuleTableViewCell", bundle: nil)
    }
    
    // set up the cell
    public func configure(with title:String){
        moduleLabel.text = title
        okBtn.isSelected.toggle()
        let initConf = 66
        delegate?.changeConfidence(module: title, confidence: initConf)

    }

    //  *********************   button  and  actions  *********************
    
    @IBAction func badBtnClicked(_ sender: UIButton) { // not confident in module
        let module = moduleLabel.text
        let difficulty = 99
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
            goodBtn.isSelected.toggle()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
