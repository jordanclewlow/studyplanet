//
//  ViewController.swift
//  moduletableproject
//
//  Created by Jordan on 23/12/2020.
//

import UIKit


class ModuleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // data persistence
    let defaults = UserDefaults.standard

    // initialise variables
    var modules = [String]() // users modules
    var dailyStudyHours : Int! // default daily hours for study
    var modulesDict = [String : Int]() //modules:confidence
    var selectedDays = [String]()
    var interval = 2
    var startingTime = 10
    
    
    // declare outlets
    @IBOutlet weak var applyBtnOutlet: UIButton!
    @IBOutlet weak var mondayBtnOutlet: UIButton!
    @IBOutlet weak var tuesdayBtnOutlet: UIButton!
    @IBOutlet weak var wednesdayBtnOutlet: UIButton!
    @IBOutlet weak var thursdayBtnOutlet: UIButton!
    @IBOutlet weak var fridayBtnOutlet: UIButton!
    @IBOutlet weak var saturdayBtnOutlet: UIButton!
    @IBOutlet weak var sundayBtnOutlet: UIButton!
    @IBOutlet weak var moduleTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControlOutlet: UISegmentedControl!
    //@IBOutlet weak var startingTimeSegmentedControlOutlet: UISegmentedControl!
    @IBOutlet weak var moduleMessageLabel: UILabel!
    @IBOutlet var moduleTable: UITableView!

    
    
    
    //  *********************   button  and  actions  *********************
    @IBAction func applyBtn(_ sender: UIButton) {
        // create object for controller
        let barViewController = self.tabBarController?.viewControllers
        let svc = barViewController![1] as! PlanViewController  // planner
        
        // store values
        defaults.setValue(dailyStudyHours, forKey: "dailyStudyHours")
        defaults.setValue(modulesDict, forKey: "modulesDict")
        defaults.setValue(modules, forKey: "modules")
        defaults.setValue(selectedDays, forKey: "selectedDays")

        // change values on the other view controller
        svc.dailyStudyHours = dailyStudyHours
        svc.modulesDict = modulesDict
        svc.modules = modules
        svc.selectedDays = selectedDays
        //svc.startingTime = startingTime

        // error message if something not chosen
        if(modules.count == 0 || selectedDays == [] || dailyStudyHours == nil){
            let alert = UIAlertController(title: "Please fill out all criteria", message:nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default) { (_) in }
            alert.addAction(action)
            present(alert, animated:true)
            
        } else{
            let modulesWithHoursDict = svc.calculateHoursPerModule()
            svc.generateTimeTable(weeklyAllocatedHours: modulesWithHoursDict)
            svc.tableView.reloadData()
            _ = self.tabBarController?.selectedIndex = 1

        }
        
        
       
        
    }
    
    
    //change daily hours to segmentIndex
    @IBAction func dailyHoursSegmentedControl(_ sender: UISegmentedControl) {
        dailyStudyHours = sender.selectedSegmentIndex+1
    }
    
    
    /*@IBAction func startTimeSegmentedControl(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            startingTime = 6
        } else if (sender.selectedSegmentIndex == 1) {
            startingTime = 8
        } else if (sender.selectedSegmentIndex == 2) {
            startingTime = 10
        } else if (sender.selectedSegmentIndex == 1){
            startingTime = 12
        }
    }*/
    
    // add module buton
    @IBAction func addButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add subject", message:nil, preferredStyle: .alert)
        alert.addTextField {(moduleTF) in moduleTF.placeholder = "Subject"}
        
        let action = UIAlertAction(title: "add", style: .default) { (_) in
            guard let module = alert.textFields?.first?.text else {return}
            self.add(module) }
        
        alert.addAction(action)
        present(alert, animated:true)
    }
    
    
    
    // buttons for selecting days
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
            button.backgroundColor = UIColor.darkGray
            button.isSelected = true
            selectedDays.append("monday")
            button.backgroundColor =  UIColor.darkGray
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
            button.backgroundColor =  UIColor.darkGray
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
            button.backgroundColor =  UIColor.darkGray
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
            button.backgroundColor = UIColor.darkGray
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
            button.backgroundColor = UIColor.darkGray
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
            button.backgroundColor = UIColor.darkGray
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
            button.backgroundColor = UIColor.darkGray

        }
    }
    
    
    
    //  *********************       functions        *********************

    // add the module
    func add(_ module: String) {
        let index = 0
        modules.insert(module, at: index)
        modulesDict.updateValue(50, forKey: module)
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .top)
    }
    
    // change  confidence
    func changeConfidence(module: String, confidence: Int){
        modulesDict.updateValue(confidence, forKey: module)
    }
    
    // give buttons circle backgroounds
    func makeIntoCircle(button: UIButton) {
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.width / 2
        button.clipsToBounds = true
    }
    
    
    
    //  *********************       modules table        *********************
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let module = modules[indexPath.row]
       let customCell = tableView.dequeueReusableCell(withIdentifier: ModuleTableViewCell.identifier, for: indexPath) as! ModuleTableViewCell
        customCell.delegate = self
        customCell.configure(with: module)
        return customCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        modules.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
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
        
        
        // set up UI
        applyBtnOutlet.layer.cornerRadius = 13
        applyBtnOutlet.backgroundColor = UIColor.systemGray6
        applyBtnOutlet.setTitleColor(UIColor.black, for: UIControl.State.normal)

        
        makeIntoCircle(button: mondayBtnOutlet)
        mondayBtnOutlet.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        mondayBtnOutlet.setTitleColor(UIColor.white, for: UIControl.State.selected)
        mondayBtnOutlet.backgroundColor = UIColor.clear

        makeIntoCircle(button: tuesdayBtnOutlet)
        tuesdayBtnOutlet.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        tuesdayBtnOutlet.setTitleColor(UIColor.white, for: UIControl.State.selected)
        tuesdayBtnOutlet.backgroundColor = UIColor.clear
        
        makeIntoCircle(button: wednesdayBtnOutlet)
        wednesdayBtnOutlet.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        wednesdayBtnOutlet.setTitleColor(UIColor.white, for: UIControl.State.selected)
        wednesdayBtnOutlet.backgroundColor = UIColor.clear
        
        makeIntoCircle(button: thursdayBtnOutlet)
        thursdayBtnOutlet.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        thursdayBtnOutlet.setTitleColor(UIColor.white, for: UIControl.State.selected)
        thursdayBtnOutlet.backgroundColor = UIColor.clear
        
        makeIntoCircle(button: fridayBtnOutlet)
        fridayBtnOutlet.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        fridayBtnOutlet.setTitleColor(UIColor.white, for: UIControl.State.selected)
        fridayBtnOutlet.backgroundColor = UIColor.clear
        
        makeIntoCircle(button: saturdayBtnOutlet)
        saturdayBtnOutlet.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        saturdayBtnOutlet.setTitleColor(UIColor.white, for: UIControl.State.selected)
        saturdayBtnOutlet.backgroundColor = UIColor.clear
        
        makeIntoCircle(button: sundayBtnOutlet)
        sundayBtnOutlet.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        sundayBtnOutlet.setTitleColor(UIColor.white, for: UIControl.State.selected)
        sundayBtnOutlet.backgroundColor = UIColor.clear
      
        
        // daily hours slider
        // selected option color
        segmentedControlOutlet.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)

        // color of other options
        segmentedControlOutlet.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        
        
        // retrieve values from user defaults
        dailyStudyHours = defaults.integer(forKey: "dailyStudyHours") as? Int ?? Int()
        segmentedControlOutlet.selectedSegmentIndex = dailyStudyHours-1
        
        /*
        startingTime = defaults.integer(forKey: "startingTime")
        var startingTimeIndex = 0
        if(startingTime == 6){
            startingTimeIndex = 0
        } else if (startingTime == 8){
            startingTimeIndex = 1
        }else if (startingTime == 10){
            startingTimeIndex = 2
        }else if (startingTime == 12){
            startingTimeIndex = 3
        }
        startingTimeSegmentedControlOutlet.selectedSegmentIndex = startingTime
        */
            
        modules = defaults.array(forKey:"modules") as? [String] ?? [String]()
        modulesDict = defaults.dictionary(forKey: "modulesDict") as? [String:Int] ?? [String:Int]()
        selectedDays = defaults.array(forKey: "selectedDays") as? [String] ?? [String]()
        
        // set up selected day buttons
        for day in selectedDays{
            if(day == "monday"){
                mondayBtnOutlet.isSelected=true
                mondayBtnOutlet.backgroundColor = UIColor.lightGray
            } else if(day == "tuesday"){
                tuesdayBtnOutlet.isSelected=true
                tuesdayBtnOutlet.backgroundColor = UIColor.lightGray
            } else if(day == "wednesday"){
                wednesdayBtnOutlet.isSelected=true
                wednesdayBtnOutlet.backgroundColor = UIColor.lightGray
            } else if(day == "thursday"){
                thursdayBtnOutlet.isSelected=true
                thursdayBtnOutlet.backgroundColor = UIColor.lightGray
            } else if(day == "friday"){
                fridayBtnOutlet.isSelected=true
                fridayBtnOutlet.backgroundColor = UIColor.lightGray
            } else if(day == "saturday"){
                saturdayBtnOutlet.isSelected=true
                saturdayBtnOutlet.backgroundColor = UIColor.lightGray
            } else if(day == "sunday"){
                sundayBtnOutlet.isSelected=true
                sundayBtnOutlet.backgroundColor = UIColor.lightGray
            }
            
            
            // reload module table
            tableView.reloadData()
        }
        
        // Do any additional setup after loading the view.*/
    }


}

