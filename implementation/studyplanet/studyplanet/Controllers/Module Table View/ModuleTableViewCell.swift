//
//  ModuleTableViewCell.swift
//  moduletableproject
//
//  Created by Jordan on 23/12/2020.
//

import UIKit

class ModuleTableViewCell: UITableViewCell {

    static let identifier = "ModuleTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "ModuleTableViewCell", bundle: nil)
    }
    
    public func configure(with title:String){
        moduleLabel.text = "test"
    }
    
    @IBOutlet var moduleLabel: UILabel!
    @IBOutlet var moduleSlider: UISlider!
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
