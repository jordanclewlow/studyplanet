//
//  ViewController.swift
//  moduletableproject
//
//  Created by Jordan on 23/12/2020.
//

import UIKit


class ModuleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    
    @IBOutlet weak var moduleMessageLabel: UILabel!
    
    var modules = [String]()
    var modulesDict = [String : Int]()                          //modules:confidence
    var confidences = [String]()
    var selectedDays = ["monday","tuesday","wednesday","thursday","friday","saturday","sunday"]
    var dailyStudyHours = 2 // default
    var interval : Int!
    var startingTime = 10

    @IBOutlet weak var mondayBtnOutlet: UIButton!
    @IBOutlet weak var tuesdayBtnOutlet: UIButton!
    @IBOutlet weak var wednesdayBtnOutlet: UIButton!
    @IBOutlet weak var thursdayBtnOutlet: UIButton!
    @IBOutlet weak var fridayBtnOutlet: UIButton!
    
    @IBOutlet weak var saturdayBtnOutlet: UIButton!
    
    @IBOutlet weak var sundayBtnOutlet: UIButton!
    
    
    @IBOutlet weak var moduleTitleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addButton(_ sender: UIButton) {
        

        let alert = UIAlertController(title: "add module", message:nil, preferredStyle: .alert)
        alert.addTextField {(moduleTF) in
            moduleTF.placeholder = "COMP101"
        }
        
        let action = UIAlertAction(title: "add", style: .default) { (_) in
            guard let module = alert.textFields?.first?.text else {return}
            self.add(module)
        }
        alert.addAction(action)
        present(alert, animated:true)
    }
    
    func add(_ module: String) {
        let index = 0
        modules.insert(module, at: index)
        modulesDict.updateValue(50, forKey: module)
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .top)
    }
    
    func changeConfidence(module: String, confidence: Int){
        modulesDict.updateValue(confidence, forKey: module)
    }
    
    
    @IBAction func toPlanBtn(_ sender: UIButton) {
        if(modules.count != 0){
            performSegue(withIdentifier: "plannerSegue", sender: nil )
        }
    }
    func findAmountOfSessions() -> Int{
        var answer = startingTime
        for _ in 1...dailyStudyHours {
            answer += interval
            if (answer >= 24){
                answer = answer - interval
                break
            }
        }
        return answer
    }
    @IBOutlet weak var dailyTotalSlider: UISlider!


    // reference actions
    @IBAction func dailyTotalSliderChanged(_ sender: UISlider) {
        dailyStudyHours = Int(sender.value) // change study hours to slider value
    }
    
    @IBAction func intervalSliderChanged(_ sender: UISlider) {
        interval = Int(sender.value) // change study hours to slider value
    }
    
    func makeIntoCircle(button: UIButton) {
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.width / 2
        button.clipsToBounds = true
    }
    
    @IBAction func mondayButton(_ sender: UIButton) {
         

        let button = sender
        if button.isSelected {
                // set deselected
            button.isSelected = false
            button.backgroundColor = UIColor.clear
            
            let mondayPos = selectedDays.firstIndex(of: "monday")
            selectedDays.remove(at: mondayPos!)
            
        } else {
            // set selected
            button.backgroundColor = UIColor.lightGray

            button.isSelected = true
            selectedDays.append("monday")
            button.backgroundColor = UIColor.lightGray

        }
    }
    
    @IBAction func tuesdayButton(_ sender: UIButton) {
         

        let button = sender
        if button.isSelected {
                // set deselected
            button.isSelected = false
            let tuesdayPos = selectedDays.firstIndex(of: "tuesday")
            selectedDays.remove(at: tuesdayPos!)
            button.backgroundColor = UIColor.clear
        } else {
            // set selected
            button.isSelected = true
            selectedDays.append("tuesday")
            button.backgroundColor = UIColor.lightGray

        }
    }
    @IBAction func wednesdayButton(_ sender: UIButton) {
         

        let button = sender
        if button.isSelected {
                // set deselected
            button.isSelected = false
            let wednesdayPos = selectedDays.firstIndex(of: "wednesday")
            selectedDays.remove(at: wednesdayPos!)
            button.backgroundColor = UIColor.clear

        } else {
            // set selected
            button.isSelected = true
            selectedDays.append("wednesday")
            button.backgroundColor = UIColor.lightGray

        }
    }
    
    @IBAction func thursdayButton(_ sender: UIButton) {
         

        let button = sender
        if button.isSelected {
                // set deselected
            button.isSelected = false
            let thursdayPos = selectedDays.firstIndex(of: "thursday")
            selectedDays.remove(at: thursdayPos!)
            button.backgroundColor = UIColor.clear

        } else {
            // set selected
            button.isSelected = true
            selectedDays.append("thursday")
            button.backgroundColor = UIColor.lightGray

        }
    }
    
    @IBAction func fridayButton(_ sender: UIButton) {
         

        let button = sender
        if button.isSelected {
                // set deselected
            button.isSelected = false
            let fridayPos = selectedDays.firstIndex(of: "friday")
            selectedDays.remove(at: fridayPos!)
            button.backgroundColor = UIColor.clear


            
        } else {
            // set selected
            button.isSelected = true
            selectedDays.append("friday")
            button.backgroundColor = UIColor.lightGray

        }
    }
    
    @IBAction func saturdayButton(_ sender: UIButton) {
         
        let button = sender
        if button.isSelected {
                // set deselected
            button.isSelected = false
            let saturdayPos = selectedDays.firstIndex(of: "saturday")
            selectedDays.remove(at: saturdayPos!)
            button.backgroundColor = UIColor.clear

        } else {
            // set selected
            button.isSelected = true
            selectedDays.append("saturday")
            button.backgroundColor = UIColor.lightGray

        }
    }
    
    @IBAction func sundayButton(_ sender: UIButton) {
         

        let button = sender
        if button.isSelected {
                // set deselected
            button.isSelected = false
            let sundayPos = selectedDays.firstIndex(of: "sunday")
            selectedDays.remove(at: sundayPos!)
            button.backgroundColor = UIColor.clear

        } else {
            // set selected
            button.isSelected = true
            selectedDays.append("sunday")
            button.backgroundColor = UIColor.lightGray

        }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("in module tableview")
       let module = modules[indexPath.row]
       let customCell = tableView.dequeueReusableCell(withIdentifier: ModuleTableViewCell.identifier, for: indexPath) as! ModuleTableViewCell
        customCell.configure(with: module)
        
        customCell.delegate = self
        return customCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        modules.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }


    @IBOutlet var moduleTable: UITableView!
    
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "plannerSegue" {
            let vc = segue.destination as! PlanViewController
            vc.selectedDays = selectedDays
            vc.modules = modules
            vc.modulesDict = modulesDict
            vc.dailyStudyHours = dailyStudyHours
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        moduleTable.register(ModuleTableViewCell.nib(), forCellReuseIdentifier: ModuleTableViewCell.identifier)
        
        moduleTable.delegate = self
        moduleTable.dataSource = self
        
        makeIntoCircle(button: mondayBtnOutlet)
        mondayBtnOutlet.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        mondayBtnOutlet.setTitleColor(UIColor.white, for: UIControl.State.selected)
        
        makeIntoCircle(button: tuesdayBtnOutlet)
        tuesdayBtnOutlet.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        tuesdayBtnOutlet.setTitleColor(UIColor.white, for: UIControl.State.selected)
        
        makeIntoCircle(button: wednesdayBtnOutlet)
        wednesdayBtnOutlet.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        wednesdayBtnOutlet.setTitleColor(UIColor.white, for: UIControl.State.selected)
        
        makeIntoCircle(button: thursdayBtnOutlet)
        thursdayBtnOutlet.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        thursdayBtnOutlet.setTitleColor(UIColor.white, for: UIControl.State.selected)
        
        makeIntoCircle(button: fridayBtnOutlet)
        mondayBtnOutlet.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        mondayBtnOutlet.setTitleColor(UIColor.white, for: UIControl.State.selected)
        
        makeIntoCircle(button: saturdayBtnOutlet)
        saturdayBtnOutlet.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        saturdayBtnOutlet.setTitleColor(UIColor.white, for: UIControl.State.selected)
        
        makeIntoCircle(button: sundayBtnOutlet)
        sundayBtnOutlet.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        sundayBtnOutlet.setTitleColor(UIColor.white, for: UIControl.State.selected)
        

        
        // Do any additional setup after loading the view.*/
    }


}

