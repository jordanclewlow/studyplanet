
//import frameworks
import UIKit
import JTAppleCalendar


class PlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = UserDefaults.standard

    // instantiate outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var heresYourLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var planTable: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarBox: JTAppleCalendarView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var streakLabel: UILabel!
    
    //instantiate variables
  
    var modules = [String]() // users modules
    var dailyStudyHours : Int! // default daily hours for study
    var modulesDict = [String : Int]() //modules:confidence
    var selectedDays = [String]()
    var startingTime = 10
    var interval = 2
    var daysDict = [String : [Int:String]] () // [days : [time:modules]]
    var timesDict = [Int:String]() // time:module
    var dayOfTheWeekString = "" // day today "monday"
    var daySelected = ""        // day selected
    var selectedDayNumber = 0   // day selected number 14    (14th march)
    var dayColumn = 0       // column day belongs to on calendar
    var currentMonth = ""   // current month

        // array of modules on each days
    var monday = [String]()     // aka [english, maths, spanish, english]
    var tuesday = [String]()
    var wednesday = [String]()
    var thursday = [String]()
    var friday = [String]()
    var saturday = [String]()
    var sunday = [String]()
    
        // array of completed sessions
    var mondayCompleted = [Bool]()     // aka [true, false, false, true]
    var tuesdayCompleted = [Bool]()
    var wednesdayCompleted = [Bool]()
    var thursdayCompleted = [Bool]()
    var fridayCompleted = [Bool]()
    var saturdayCompleted = [Bool]()
    var sundayCompleted = [Bool]()

    
    // progress values
    var stars = 0 // amount of stars user has
    var level = 1 // users level
    var levels = [0,250,500,700,1000,1300,1700,2200,3800,4700,5700,7000,8000,9000,10000,12000,14000,160000,18000,20000,25000] //amount of stars needed for each level
    var progress = 0.0  // percentage of closeness to next level
    var streak = 0
    
    
    // add into array
    func add(_ module: String) {
        let index = 0
        modules.insert(module, at: index)
        modulesDict.updateValue(50, forKey: module)
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .top)
        tableView.reloadData()
    }
    
    // formatter for dates
    // count fired for timer running in background
    let formatter = DateFormatter()
    var countFired = 0
    
    // Calculate percentage based on given values
    public func calculatePercentage(value:Double,percentageVal:Double)->Double{
        let val = value * percentageVal
        return val / 100.0
    }
    
    // generate the days / sessions
    public func generateTimeTable(weeklyAllocatedHours: Dictionary<String,Double>) {
        let weeklyAllocated = weeklyAllocatedHours // how many hours allocated to each module
     
        // the hours for each modules
        var moduleCounter = [String:Int]() // how many times the module shows
        
        for module in modules{ // initialise counter
            moduleCounter[module] = 0
        }
        
        timesDict.removeAll()
        
        // reset users schedule
        monday = []
        tuesday = []
        wednesday = []
        thursday = []
        friday = []
        saturday = []
        sunday = []
        mondayCompleted = []
        tuesdayCompleted = []
        wednesdayCompleted = []
        thursdayCompleted = []
        fridayCompleted = []
        saturdayCompleted = []
        sundayCompleted = []

        var iterator = 0
        for day in selectedDays { // each day
            var time = startingTime // start at the starting time
            for _ in 1...dailyStudyHours{ // for each hour
                
                if (modules.count==0){ // if not modules, break
                    break
                }
                
                let module = modules[iterator] //  e.g english
                timesDict.updateValue(module , forKey: time) // add module to that time slot
                moduleCounter[module]! += 1 // increase counter
                
                let roundedHours = weeklyAllocated[module]!.rounded() // round the allocated hours
                
                // stop module from being revised after max hours for that module is reached
                if (Double(moduleCounter[module]!)) == roundedHours {
                    modules.remove(at: iterator )
               }
                
                // iterate through each module, if reach end, restart
                if (iterator == (modules.count)-1) || (modules.count == 1) || (iterator == modules.count) {
                    iterator=0
                    
                } else {
                    iterator = iterator+1
                }
                
                time = time+interval // next time slot is..
            }
            
        let revisionTimes = Array(timesDict.values).sorted(by: <) // time:hour from earliest to latest
            
        // add revision to that day
            if day == "monday" {
                monday.append(contentsOf: revisionTimes)
                
                // generate sessions for that day as false
                for _ in 1...monday.count {
                    mondayCompleted.append(false)
                }
                
            } else if day == "tuesday" {
                tuesday.append(contentsOf: revisionTimes)
                
                // generate sessions for that day as false
                for _ in 1...tuesday.count {
                    tuesdayCompleted.append(false)
                }
                
            } else if day == "wednesday" {
                wednesday.append(contentsOf: revisionTimes)
                
                // generate sessions for that day as false
                for _ in 1...wednesday.count {
                    wednesdayCompleted.append(false)
                }
                
            } else if day == "thursday" {
                thursday.append(contentsOf: revisionTimes)
                
                // generate sessions for that day as false
                for _ in 1...thursday.count {
                    thursdayCompleted.append(false)
                }
                
            } else if day == "friday" {
                friday.append(contentsOf: revisionTimes)
            
                // generate sessions for that day as false
                for _ in 1...friday.count {
                    fridayCompleted.append(false)
                }
                
            } else if day == "saturday" {
                saturday.append(contentsOf: revisionTimes)
                
                // generate sessions for that day as false
                for _ in 1...saturday.count {
                    saturdayCompleted.append(false)
                }
                
            } else if day == "sunday" {
                sunday.append(contentsOf: revisionTimes)
                
                // generate sessions for that day as false
                for _ in 1...sunday.count {
                    sundayCompleted.append(false)
                }

            
            }
            
            daysDict.updateValue(timesDict , forKey: day)    //  [ day : [time of day : module] ]
        }
      
        return
    }
    
    
    


    
    // Calculate how many hours of revision
    func calculateHoursPerModule() -> Dictionary<String,Double>{
        
        // find amount of hours max in a week
        let totalWeeklyStudyHours = dailyStudyHours * selectedDays.count
    
        
    // find percentage of each modules confidence compared to sum of confidences

        // find sum
        var sumConfidence = 0
        for module in modules
        {
            sumConfidence = sumConfidence + modulesDict[module]!
        }
        
        // instantiate the dictionary
        var modulesWithWeeklyHours = [String:Double]() // module : how many hours in a week
        
        // go through each module and find how many hours per week
        for module in modules
        {
            let moduleTitle = module
            let percentageOfConfidence = Double(modulesDict[moduleTitle]!) / Double(sumConfidence) * 100
            let hours = calculatePercentage(value: Double(totalWeeklyStudyHours),percentageVal: percentageOfConfidence)            
            modulesWithWeeklyHours.updateValue(hours, forKey: moduleTitle)
        }
        
        // modules : how many hours that modules show up in planner (week)
        return(modulesWithWeeklyHours)
    }

    
    // *******************     revision planner table view     *************************
    
    // how many rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if daySelected == "monday" {
            rows = monday.count
        } else if daySelected == "tuesday" {
            rows = tuesday.count
        }else if daySelected == "wednesday" {
            rows = wednesday.count
        }else if daySelected == "thursday" {
            rows = thursday.count
        }else if daySelected == "friday" {
            rows = friday.count
        }else if daySelected == "saturday" {
            rows = saturday.count
        }else if daySelected == "sunday" {
            rows = sunday.count
        }
        return rows
    }

    
    // show cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let customCell = tableView.dequeueReusableCell(withIdentifier: PlanTableViewCell.identifier, for: indexPath) as! PlanTableViewCell
        
        customCell.delegate = self
        // time goes in multiples of 2
        var time = startingTime
        time = time + (interval*indexPath.row)
        
        // show slots for the specific day
        if daySelected == "monday" {
            customCell.configure(with: monday[indexPath.row], time: time, indexPath: indexPath, selectedDayNum: selectedDayNumber, selectedDayOfTheWeekString: daySelected)
        } else if daySelected == "tuesday" {
            customCell.configure(with: tuesday[indexPath.row], time: time, indexPath: indexPath, selectedDayNum: selectedDayNumber, selectedDayOfTheWeekString: daySelected)
        } else if daySelected == "wednesday" {
            customCell.configure(with: wednesday[indexPath.row], time: time, indexPath: indexPath, selectedDayNum: selectedDayNumber, selectedDayOfTheWeekString: daySelected)
        } else if daySelected == "thursday" {
            customCell.configure(with: thursday[indexPath.row], time: time, indexPath: indexPath, selectedDayNum: selectedDayNumber, selectedDayOfTheWeekString: daySelected)
        } else if daySelected == "friday" {
            customCell.configure(with: friday[indexPath.row], time: time, indexPath: indexPath, selectedDayNum: selectedDayNumber, selectedDayOfTheWeekString: daySelected)
        } else if daySelected == "saturday" {
            customCell.configure(with: saturday[indexPath.row], time: time, indexPath: indexPath, selectedDayNum: selectedDayNumber, selectedDayOfTheWeekString: daySelected)
        } else if daySelected == "sunday" {
            customCell.configure(with: sunday[indexPath.row], time: time, indexPath: indexPath, selectedDayNum: selectedDayNumber, selectedDayOfTheWeekString: daySelected)
        }
        customCell.indexPathForCell = indexPath
        return customCell
    }

    // bounce animation
    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.15)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // load progress view so that badges show up
        let progressVC = self.tabBarController?.viewControllers?[2] as! ProgressViewController
        progressVC.loadView()
        
        
        // ignore constraint erros
        defaults.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")

        // retrieve variables fron user defaults
        dailyStudyHours = defaults.integer(forKey: "dailyStudyHours") as? Int ?? Int()
        modules = defaults.array(forKey:"modules") as? [String] ?? [String]()
        modulesDict = defaults.dictionary(forKey: "modulesDict") as? [String:Int] ?? [String:Int]()
        selectedDays = defaults.array(forKey: "selectedDays") as? [String] ?? [String]()
        self.stars = defaults.integer(forKey: "stars")

        // set line underneath calendar
        calendarBox.setBottomBorder()
        
        // set up planner  table
        planTable.register(PlanTableViewCell.nib(), forCellReuseIdentifier: PlanTableViewCell.identifier)
        planTable.delegate = self
        planTable.dataSource = self
        
        // if there is modules, generate the planner
        if(modules.count != 0){
            generateTimeTable(weeklyAllocatedHours: calculateHoursPerModule())
        }

        
        // find day and show the plan for that day
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dayOfTheWeekString = dateFormatter.string(from: date)
        
        // find month for label
        dateFormatter.dateFormat = "LLLL"
        currentMonth = dateFormatter.string(from: date)
        daySelected = dayOfTheWeekString.lowercased()
        
        // scroll to date animation
        calendarView.scrollToDate(date) {
           self.calendarView.selectDates([date])
        }
        
        // select current day
        daySelected = dayOfTheWeekString

        mondayCompleted = defaults.array(forKey: "mondayCompleted") as? [Bool] ?? mondayCompleted
        tuesdayCompleted = defaults.array(forKey: "tuesdayCompleted") as? [Bool] ?? tuesdayCompleted
        wednesdayCompleted = defaults.array(forKey: "wednesdayCompleted") as? [Bool] ?? wednesdayCompleted
        thursdayCompleted = defaults.array(forKey: "thursdayCompleted") as? [Bool] ?? thursdayCompleted
        fridayCompleted = defaults.array(forKey: "fridayCompleted") as? [Bool] ?? fridayCompleted
        saturdayCompleted = defaults.array(forKey: "saturdayCompleted") as? [Bool] ?? saturdayCompleted
        sundayCompleted = defaults.array(forKey: "sundayCompleted") as? [Bool] ?? sundayCompleted
        
        // refresh the planner
        tableView.reloadData()
        
        // runs in background: retrieves stars, levels and updates progress
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in self.countFired += 1
            
            DispatchQueue.main.async { [self] in
                self.stars = defaults.integer(forKey: "stars")
                self.starsLabel.text = String(self.stars)//keep updating label
                
                // show correct streak
                self.streak = defaults.integer(forKey: "streak")
                self.streakLabel.text = String(self.streak) //keep updating label
                
                if (self.stars != 0){ // if stars isnt 0
                    for lvl in self.levels {  // for each level
                        if (stars < lvl) { // where stars needed is higher than stars
                            level = levels.firstIndex(of: lvl)!
                            levelLabel.text = String(level)
                            
                            // store in data
                            defaults.setValue(level, forKey: "level")
                            
                            
                            self.starsLabel.text = String(self.stars) // + "/" + String(lvl) //keep updating label
                            
                            self.progress = Double(stars) / Double(lvl)
                            
                            let barViewController = self.tabBarController?.viewControllers
                            let svc = barViewController![2] as! ProgressViewController
                            svc.progress = CGFloat(self.progress)
                            
                            break
                        }
                    }
                }
        
            }
        }
    }
}

// uppercase first letter of string
extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}

// set line underneath calendar
extension JTAppleCalendarView {
  func setBottomBorder() {
    self.layer.backgroundColor = UIColor.white.cgColor
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.lightGray.cgColor
    self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    self.layer.shadowOpacity = 1.0
    self.layer.shadowRadius = 0.0
  }
}

// *******************       calendar         **************************
extension PlanViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.textColor = UIColor.white
        handleHiddenCells(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    // if day selected show plan for that day
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        cell.dateLabel.textColor = UIColor.red
        heresYourLabel.isHidden = false
        monthLabel.isHidden = false
       if cellState.isSelected {
            cell.selectedView.isHidden = false
            selectedDayNumber = Int(cellState.text)!
            cell.selectedView.layer.cornerRadius = cell.selectedView.frame.width / 2

            cell.selectedView.layer.add(bounceAnimation, forKey: nil)
            
            // change selected day
            if cellState.column() == 0{
                
                daySelected = "monday"
            } else if cellState.column() == 1{
                daySelected = "tuesday"
            }else if cellState.column() == 2{
                daySelected = "wednesday"
            }else if cellState.column() == 3{
                daySelected = "thursday"
            }else if cellState.column() == 4{
                daySelected = "friday"
            }else if cellState.column() == 5{
                daySelected = "saturday"
            }else if cellState.column() == 6{
                daySelected = "sunday"
            }

        //print(cellState.column())
            // show day month year
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            let yearString = dateFormatter.string(from: date)
            monthLabel.text = cellState.text + " " + currentMonth + " " + yearString
            tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .right)
        } else { // if cell isnt not selected
            cell.dateLabel.textColor = UIColor.black
            cell.selectedView.isHidden = true
        }
    }
    
    func handleHiddenCells(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
           cell.isHidden = false
        } else {
           cell.isHidden = true
        }
    }
    
    // configure cell
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }

    // configure cell
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    // show dates
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: myCustomCell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        // show date
        myCustomCell.dateLabel.text = cellState.text
        
        // make a circle
        myCustomCell.dateLabel.textColor = UIColor.black
        myCustomCell.selectedView.layer.masksToBounds = true
        myCustomCell.selectedView.layer.cornerRadius = myCustomCell.selectedView.frame.width / 2
        myCustomCell.selectedView.clipsToBounds = true
        myCustomCell.selectedView.isHidden = true

        return myCustomCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath)     {
        _ = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
    }

    // configure the calendar

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
                
        let numberOfRows=1
        let startDate = formatter.date(from: "2021 01 01")!
        let endDate = formatter.date(from: "2021 12 31")!
        
        
        return ConfigurationParameters(startDate: startDate,
                                           endDate: endDate,
                                           numberOfRows: numberOfRows,
                                           generateInDates: .forAllMonths,
                                           generateOutDates: .tillEndOfRow,
                                           firstDayOfWeek: .monday,
                                           hasStrictBoundaries: false)
    }
}
    

