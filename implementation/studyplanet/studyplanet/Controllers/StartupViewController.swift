//
//  StartupViewController.swift
//  moduletableproject
//
//  Created by Jordan on 23/12/2020.
//

import UIKit

class StartupViewController: UIViewController{
    // instantiate variables
    var name : String!
    var course : String!
    var modules = [String]()
    var selectedDays = ["monday","tuesday","wednesday","thursday","friday","saturday","sunday"]
    var dailyStudyHours : Int!
    
    // reference outlets
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var courseTF: UITextField!
    @IBOutlet weak var dailyTotalSlider: UISlider!


    // reference actions
    @IBAction func dailyTotalSliderChanged(_ sender: UISlider) {
        dailyStudyHours = Int(sender.value) // change study hours to slider value
    }
    
    @IBAction func toModules(_ sender: UIButton) {
        name = nameTF.text!
        course = courseTF.text!
        
        if name == "" || course == ""
        {
            // Create new Alert
            let dialogMessage = UIAlertController(title: "Error", message: "Please answer all questions.", preferredStyle: .alert)
             
             // Create OK button with action handler
             let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                 print("Ok button tapped")
              })
             
             //Add OK button to a dialog message
             dialogMessage.addAction(ok)
             // Present Alert to
             self.present(dialogMessage, animated: true, completion: nil)
        }
        else{
            self.performSegue(withIdentifier: "moduleSegue", sender: self)
        }
    }
    
    @IBAction func mondayButton(_ sender: UIButton) {
        let button = sender
        if button.isSelected {
                // set deselected
            button.isSelected = false
            
            let mondayPos = selectedDays.firstIndex(of: "monday")
            selectedDays.remove(at: mondayPos!)
            
        } else {
            // set selected
            button.isSelected = true
            selectedDays.append("monday")
        }
    }
    
    @IBAction func tuesdayButton(_ sender: UIButton) {
        let button = sender
        if button.isSelected {
                // set deselected
            button.isSelected = false
            let tuesdayPos = selectedDays.firstIndex(of: "tuesday")
            selectedDays.remove(at: tuesdayPos!)
        } else {
            // set selected
            button.isSelected = true
            selectedDays.append("tuesday")
        }
    }
    @IBAction func wednesdayButton(_ sender: UIButton) {
        let button = sender
        if button.isSelected {
                // set deselected
            button.isSelected = false
            let wednesdayPos = selectedDays.firstIndex(of: "wednesday")
            selectedDays.remove(at: wednesdayPos!)
        } else {
            // set selected
            button.isSelected = true
            selectedDays.append("wednesday")
        }
    }
    
    @IBAction func thursdayButton(_ sender: UIButton) {
        let button = sender
        if button.isSelected {
                // set deselected
            button.isSelected = false
            let thursdayPos = selectedDays.firstIndex(of: "thursday")
            selectedDays.remove(at: thursdayPos!)
        } else {
            // set selected
            button.isSelected = true
            selectedDays.append("thursday")
        }
    }
    
    @IBAction func fridayButton(_ sender: UIButton) {
        let button = sender
        if button.isSelected {
                // set deselected
            button.isSelected = false
            let fridayPos = selectedDays.firstIndex(of: "friday")
            selectedDays.remove(at: fridayPos!)
        } else {
            // set selected
            button.isSelected = true
            selectedDays.append("friday")
        }
    }
    
    @IBAction func saturdayButton(_ sender: UIButton) {
        let button = sender
        if button.isSelected {
                // set deselected
            button.isSelected = false
            let saturdayPos = selectedDays.firstIndex(of: "saturday")
            selectedDays.remove(at: saturdayPos!)
        } else {
            // set selected
            button.isSelected = true
            selectedDays.append("saturday")
        }
    }
    
    @IBAction func sundayButton(_ sender: UIButton) {
        let button = sender
        if button.isSelected {
                // set deselected
            button.isSelected = false
            let sundayPos = selectedDays.firstIndex(of: "sunday")
            selectedDays.remove(at: sundayPos!)
        } else {
            // set selected
            button.isSelected = true
            selectedDays.append("sunday")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moduleSegue" {
            let vc = segue.destination as! ModuleViewController
            vc.name = name
            vc.course = course
            vc.selectedDays = selectedDays
            vc.dailyStudyHours = dailyStudyHours
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
