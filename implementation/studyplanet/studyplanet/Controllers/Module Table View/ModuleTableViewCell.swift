//
//  ModuleTableViewCell.swift
//  moduletableproject
//
//  Created by Jordan on 23/12/2020.
//

import UIKit



class ModuleTableViewCell: UITableViewCell {
    var delegate: ModuleViewController?
    static let identifier = "ModuleTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "ModuleTableViewCell", bundle: nil)
    }
    
    public func configure(with title:String){
        moduleLabel.text = title
    }
    
    @IBOutlet var moduleLabel: UILabel!
    @IBOutlet var moduleSlider: UISlider!
    
    
  
    @IBAction func moduleSliderChanged(_ sender: UISlider) {
        let module = moduleLabel.text
        let confidence = Int(sender.value)
        
        delegate?.changeConfidence(module: module!, confidence: confidence)
        
    }
    @IBOutlet var moduleInput: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
