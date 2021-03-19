
//import frameworks
import UIKit
import JTAppleCalendar


class PlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // instantiate outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var calendarBox: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var planTable: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    var planetRed = UIColor(red: 248/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)
    /* instantiate variables
    var name : String! // users name
    var course : String! // users course
    var modules = [String]() // users modules
    var confidences = [Int]()
    var dailyStudyHours : Int!// default daily hours for study
    var startingTime = 10 // default daily hours for study
    var modulesDict = [String : Int]() //modules:confidence
    var selectedDays = [String]()
    var interval : Int!
     */
    
    var daysDict = [String : [Int:String]] () // [days : [time:modules]]
    var months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    var daySelected = ""
    var selectedDayNumber = 0 // aka 14    (14th march)
    
    var dayRow = 0
    var currentMonth = ""
    
    let hour = Calendar.current.component(.hour, from: Date())
        // array of session for each day
    var monday = [String]()
    var tuesday = [String]()
    var wednesday = [String]()
    var thursday = [String]()
    var friday = [String]()
    var saturday = [String]()
    var sunday = [String]()
    
        // array of completed sessions
    var mondayCompleted = [Bool]()
    var tuesdayCompleted = [Bool]()
    var wednesdayCompleted = [Bool]()
    var thursdayCompleted = [Bool]()
    var fridayCompleted = [Bool]()
    var saturdayCompleted = [Bool]()
    var sundayCompleted = [Bool]()
    
   
    
    // add  button
    @IBAction func addBtn(_ sender: UIButton) {
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
    
    // add into array
    func add(_ module: String) {
        let index = 0
        modules.insert(module, at: index)
        modulesDict.updateValue(50, forKey: module)
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .top)
        tableView.reloadData()
    }
    

    
    // ******************** DUMMY ********************
  
    
   var dailyStudyHours = 6 // default daily hours for study
    var startingTime = 10 // default daily hours for study
    var modulesDict = ["english" : 50 , "maths":50,"science":50]
    var modules = ["english" , "maths","science"]
   var  selectedDays = ["monday","tuesday","wednesday","thursday","friday","saturday","sunday"]
    var interval = 2
    
    // formatter for dates
    let formatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarBox.setBottomBorder()
        // planner table
        planTable.register(PlanTableViewCell.nib(), forCellReuseIdentifier: PlanTableViewCell.identifier)
        planTable.delegate = self
        planTable.dataSource = self
        
        // generate the timetable
        generateTimeTable(weeklyAllocatedHours: calculateHoursPerModule())
        
        // find day and show the plan for that day
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfTheWeekString = dateFormatter.string(from: date)
        
        // find month for label
        dateFormatter.dateFormat = "LLLL"
        currentMonth = dateFormatter.string(from: date)
        daySelected = dayOfTheWeekString.lowercased()
        
        // scroll to date animation
        calendarView.scrollToDate(date) {
           self.calendarView.selectDates([date])
        }
        
        // refresh the planner
        tableView.reloadData()
    }

    
    // Calculate percentage based on given values
    public func calculatePercentage(value:Double,percentageVal:Double)->Double{
        let val = value * percentageVal
        return val / 100.0
    }
    
    // generate the days / sessions
    public func generateTimeTable(weeklyAllocatedHours: Dictionary<String,Double>) {
        let weeklyAllocated = weeklyAllocatedHours // how many hours allocated to each module
        var timesDict = [Int:String]() // the hours for each modules
        var moduleCounter = [String:Int]() // how many times the module shows
        
        for module in modules{ // initialise counter
            moduleCounter[module] = 0
        }
        
        var iterator = 0
        for day in selectedDays { // each day
            var time = startingTime
            for _ in 1...dailyStudyHours{ // for each hour
                if (modules.count==0){
                    break
                }
                let module = modules[iterator] //  e.g english
                timesDict.updateValue(module , forKey: time) // add module for that time
                moduleCounter[module]! += 1 // increase counter
                let roundedHours = weeklyAllocated[module]!.rounded()
                if (Double(moduleCounter[module]!)) == roundedHours { // stop module from being revised after max reached
                    modules.remove(at: iterator )
               }
                if (iterator == (modules.count)-1) || (modules.count == 1) || (iterator == modules.count) { // iterate through each module, if reach end, restart
                    iterator=0
                    
                } else {
                    iterator = iterator+1
                }
                time = time+interval // revise every 2 hours
            }
            
            // add revision to that day
            let sortedKeys = Array(timesDict.values).sorted(by: <)
            if day == "monday" {
                monday.append(contentsOf: sortedKeys)
                // generate sessions for that day as false
                for _ in 1...monday.count {
                    mondayCompleted.append(false)
                }
            } else if day == "tuesday" {
                tuesday.append(contentsOf: sortedKeys)
                // generate sessions for that day as false
                for _ in 1...tuesday.count {
                    tuesdayCompleted.append(false)
                }
            } else if day == "wednesday" {
                wednesday.append(contentsOf: sortedKeys)
                // generate sessions for that day as false
                for _ in 1...wednesday.count {
                    wednesdayCompleted.append(false)
                }
            } else if day == "thursday" {
                thursday.append(contentsOf: sortedKeys)
                // generate sessions for that day as false
                for _ in 1...thursday.count {
                    thursdayCompleted.append(false)
                }
            } else if day == "friday" {
                friday.append(contentsOf: sortedKeys)
                // generate sessions for that day as false
                for _ in 1...friday.count {
                    fridayCompleted.append(false)
                }
            } else if day == "saturday" {
                saturday.append(contentsOf: sortedKeys)
                // generate sessions for that day as false
                for _ in 1...saturday.count {
                    saturdayCompleted.append(false)
                }

            } else if day == "sunday" {
                sunday.append(contentsOf: sortedKeys)
                // generate sessions for that day as false
                for _ in 1...sunday.count {
                    sundayCompleted.append(false)
                }
            }
            
            // days
            daysDict.updateValue(timesDict , forKey: day)
        }
        return
    }
    
    // Calculate how many hours of revision
    func calculateHoursPerModule() -> Dictionary<String,Double>{
                
        // sort modules desc & ascconfidence
        let modulesDescDict = modulesDict.sorted { $0.1 > $1.1 }
        let modulesAscDict = modulesDict.sorted { $0.1 < $1.1 }
        
        // create sorted arrays for desc and asc
        var descValueArray = [Int]() // array of descending sorted values
        var ascKeyArray = [String]() // array of ascending sorted keys
        for (_, value) in modulesDescDict{
            descValueArray.append(value)
        }
        for (key, _) in modulesAscDict{
            ascKeyArray.append(key)
        }

        // create new dictionary, swapping modules of biggest to smallest
        let swappedModulesDict = Dictionary(uniqueKeysWithValues: zip(ascKeyArray, descValueArray))

        // find minimum hours allocated to each module
        let weeklyStudyHours = dailyStudyHours * selectedDays.count
        _ = Double(modules.count) // atleast one hour for each module
        

        
        
        // find % of each modules confidence compared to sum of confidence
        // make array of confidence percentages
        var sumConfidence = 0
        for module in modules
        {
            sumConfidence = sumConfidence + modulesDict[module]!
        }
        var percentageWeeklyHours = [Double]() // percentage of the total hours
        for module in modules
        {
            let moduleTitle = module
            let percentageOfConfidence = (Double(swappedModulesDict[moduleTitle]!) / Double(sumConfidence)) * 100
            let hours = calculatePercentage(value: Double(weeklyStudyHours),percentageVal: percentageOfConfidence)
            percentageWeeklyHours.append(hours)
        }
        // sort percentages in desc
        percentageWeeklyHours.sort(by:>)
        // create new dictionary, with modules and swapped values as percentages
        let weeklyAllocatedHours = Dictionary(uniqueKeysWithValues: zip(ascKeyArray, percentageWeeklyHours))
        
        return(weeklyAllocatedHours)
    }
    

    
    
    
    
    
    
    
    
    
    
    func maxRows()->Int{
        var max = 0
        var counter = 0
        while max <= 24{
            max += interval
            counter += 1
        }
        return counter
    }
    
    
    
    // ****************************** PLAN TABLE VIEW ******************************
    
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
    
    /* delete when slide
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if daySelected == "monday" {
                monday.remove(at: indexPath.row)
                mondayCompleted.remove(at: indexPath.row)
            } else if daySelected == "tuesday" {
                tuesday.remove(at: indexPath.row)
                tuesdayCompleted.remove(at: indexPath.row)
            } else if daySelected == "wednesday" {
                wednesday.remove(at: indexPath.row)
                wednesdayCompleted.remove(at: indexPath.row)
            } else if daySelected == "thursday" {
                thursday.remove(at: indexPath.row)
                thursdayCompleted.remove(at: indexPath.row)
            } else if daySelected == "friday" {
                friday.remove(at: indexPath.row)
                fridayCompleted.remove(at: indexPath.row)
            } else if daySelected == "saturday" {
                saturday.remove(at: indexPath.row)
                saturdayCompleted.remove(at: indexPath.row)
            } else if daySelected == "sunday" {
                sunday.remove(at: indexPath.row)
                sundayCompleted.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    } */
    

    

}

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}

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

// ************************************************* CALENDAR *************************************************
extension PlanViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellSelected(cell: cell, cellState: cellState)
        

    }
        
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        cell.dateLabel.isHidden = false

       if cellState.dateBelongsTo == .thisMonth {
          cell.dateLabel.textColor = UIColor.black
       } else {
          cell.dateLabel.textColor = UIColor.black
       }
        
        
    }
    
    // if day selected show plan for that day
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        cell.dateLabel.isHidden = false
        if cellState.isSelected {
            
            // make a circle
            //cell.selectedView.layer.borderWidth = 1
            cell.selectedView.layer.masksToBounds = true
            cell.selectedView.layer.cornerRadius = cell.selectedView.frame.width / 2
            cell.selectedView.clipsToBounds = true
            cell.dateLabel.textColor = UIColor.white
            cell.selectedView.isHidden = false
            selectedDayNumber = Int(cellState.text)!
            
            // animate enlarge
            UIView.animate(withDuration: 0.15) {
                cell.selectedView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            }
            
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
            
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            let yearString = dateFormatter.string(from: date)
            
            monthLabel.text = cellState.text + " " + currentMonth + " " + yearString
            tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .bottom)

        } else {
            cell.dateLabel.textColor = UIColor.black
            cell.selectedView.isHidden = true
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
                                           generateInDates: .forFirstMonthOnly,
                                           generateOutDates: .off,
                                           firstDayOfWeek: .monday,
                                           hasStrictBoundaries: false)
    }
}
    

