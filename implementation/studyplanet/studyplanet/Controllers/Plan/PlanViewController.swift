
//import frameworks
import UIKit
import JTAppleCalendar


var PlanVC = PlanViewController()

class PlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // instantiate outlets
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var planTable: UITableView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    
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
    
    func add(_ module: String) {
        let index = 0
        modules.insert(module, at: index)
        modulesDict.updateValue(50, forKey: module)
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .top)
        tableView.reloadData()
    }
    
    /* instantiate variables
    var name : String! // users name
    var course : String! // users course
    var modules = [String]() // users modules
    var confidences = [Int]()
    var dailyStudyHours : Int!// default daily hours for study
    var startingTime = 10 // default daily hours for study
    var modulesDict = [String : Int]() //modules:confidence
    var selectedDays = [String]()*/
    var daysDict = [String : [Int:String]] ()
    
    
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
    
    var daySelected = ""
    var dayRow = 0
    
    
    var name = "jordan" // users name
   var course = "compsci" // users course
   var dailyStudyHours = 5 // default daily hours for study
    var startingTime = 10 // default daily hours for study
    var modulesDict = ["comp101" : 50 , "comp102":50,"comp103":50]
    var modules = ["comp101" , "comp102","comp103"]
   var  selectedDays = ["monday","tuesday","wednesday"]
    
    
    
    let formatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        planTable.register(PlanTableViewCell.nib(), forCellReuseIdentifier: PlanTableViewCell.identifier)
        planTable.delegate = self
        planTable.dataSource = self
        
        // dummy variables


        generateTimeTable(weeklyAllocatedHours: calculateHoursPerModule())
        // Do any additional setup after loading the view.
        
        
        
        // find day and show the plan for that day
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfTheWeekString = dateFormatter.string(from: date)
        
        // find month for label
        dateFormatter.dateFormat = "LLLL"
        let monthString = dateFormatter.string(from: date)
        
        daySelected = dayOfTheWeekString.lowercased()
        
        calendarView.scrollToDate(date) {
           self.calendarView.selectDates([date])
        }
        
        monthLabel.text = monthString
        if (daySelected == "monday"){
            dayRow = 1
        } else if (daySelected == "tuesday"){
            dayRow = 2
        }else if (daySelected == "wednesday"){
            dayRow = 3
        }else if (daySelected == "thursday"){
            dayRow = 4
        }else if (daySelected == "friday"){
            dayRow = 5
        }else if (daySelected == "saturday"){
            dayRow = 6
        }else if (daySelected == "sunday"){
            dayRow = 7
        }
        
        tableView.reloadData()
        
    }

    func test(){
        
    }
    // Calculate percentage based on given values
    public func calculatePercentage(value:Double,percentageVal:Double)->Double{
        let val = value * percentageVal
        return val / 100.0
    }
    
    // generate the days / sessions
    public func generateTimeTable(weeklyAllocatedHours: Dictionary<String,Double>) {
        var weeklyAllocated = weeklyAllocatedHours
        
        var timesDict = [Int:String]()
        
        var moduleCounter = [String:Int]()
        for module in modules{
            moduleCounter[module] = 0
        }
        
        var iterator = 0
        for day in selectedDays { // each day
            var time = startingTime
            for _ in 1...dailyStudyHours{ // for each hour
                let module = modules[iterator] //  e.g english
                timesDict.updateValue(module , forKey: time)
                
                
                moduleCounter[module]! += 1
                var roundedHours = weeklyAllocated[module]!.rounded()
                if (Double(moduleCounter[module]!)) == roundedHours {
                    modules.remove(at: iterator )
               }
                if (iterator == (modules.count)-1) || (modules.count == 1) || (iterator == modules.count) { // iterate through each module, if reach end, restart
                    iterator=0
                } else {
                    iterator = iterator+1
                }
                time = time+2
            }
            
            // add modules to that day
            let sortedKeys = Array(timesDict.values).sorted(by: <)
            if day == "monday" {
                monday.append(contentsOf: sortedKeys)
                
                // generate sessions for that day as false
                for sessions in 1...monday.count {
                    mondayCompleted.append(false)
                }
                
            } else if day == "tuesday" {
                tuesday.append(contentsOf: sortedKeys)
                
                // generate sessions for that day as false
                for sessions in 1...tuesday.count {
                    tuesdayCompleted.append(false)
                }
                
            } else if day == "wednesday" {
                wednesday.append(contentsOf: sortedKeys)
                
                // generate sessions for that day as false
                for sessions in 1...wednesday.count {
                    wednesdayCompleted.append(false)
                }
                
            } else if day == "thursday" {
                thursday.append(contentsOf: sortedKeys)
                
                // generate sessions for that day as false
                for sessions in 1...thursday.count {
                    thursdayCompleted.append(false)
                }
                
            } else if day == "friday" {
                friday.append(contentsOf: sortedKeys)
                
                // generate sessions for that day as false
                for sessions in 1...friday.count {
                    fridayCompleted.append(false)
                }
                
            } else if day == "saturday" {
                saturday.append(contentsOf: sortedKeys)
                
                // generate sessions for that day as false
                for sessions in 1...saturday.count {
                    saturdayCompleted.append(false)
                }
                
            } else if day == "sunday" {
                sunday.append(contentsOf: sortedKeys)
                
                // generate sessions for that day as false
                for sessions in 1...sunday.count {
                    sundayCompleted.append(false)
                }
            }
            
            
            daysDict.updateValue(timesDict , forKey: day)
        }
        configurePlanVC()
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
        for (key, value) in modulesDescDict{
            descValueArray.append(value)
        }
        for (key, value) in modulesAscDict{
            ascKeyArray.append(key)
        }

        // create new dictionary, swapping modules of biggest to smallest
        let swappedModulesDict = Dictionary(uniqueKeysWithValues: zip(ascKeyArray, descValueArray))

        // find minimum hours allocated to each module
        let weeklyStudyHours = dailyStudyHours * selectedDays.count
        let minWeeklyStudyHoursForEachModule = Double(modules.count) // atleast one hour for each module
        
        // find remaining hours of study that need to be allocated
        let hoursToBeAllocatedWeekly = Double(weeklyStudyHours) - minWeeklyStudyHoursForEachModule
        
        
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
            name = module
            let percentageOfConfidence = (Double(swappedModulesDict[name]!) / Double(sumConfidence)) * 100
            let hours = calculatePercentage(value: Double(weeklyStudyHours),percentageVal: percentageOfConfidence)
            percentageWeeklyHours.append(hours)
        }
        // sort percentages in desc
        percentageWeeklyHours.sort(by:>)
        // create new dictionary, with modules and swapped values as percentages
        let weeklyAllocatedHours = Dictionary(uniqueKeysWithValues: zip(ascKeyArray, percentageWeeklyHours))
        
        return(weeklyAllocatedHours)
    }
    

    
    // ****************************** TABLE VIEW ******************************
    
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
        
        
       // customCell.backgroundColor = UIColor.lightGray
   
        
        var time = startingTime
        time = time + (indexPath.row)*2
        if daySelected == "monday" {
            customCell.configure(with: monday[indexPath.row], time: time, indexPath: indexPath)
            
        } else if daySelected == "tuesday" {
            customCell.configure(with: tuesday[indexPath.row], time: time, indexPath: indexPath)
        } else if daySelected == "wednesday" {
            customCell.configure(with: wednesday[indexPath.row], time: time, indexPath: indexPath)
        } else if daySelected == "thursday" {
            customCell.configure(with: thursday[indexPath.row], time: time, indexPath: indexPath)
        } else if daySelected == "friday" {
            customCell.configure(with: friday[indexPath.row], time: time, indexPath: indexPath)
        } else if daySelected == "saturday" {
            customCell.configure(with: saturday[indexPath.row], time: time, indexPath: indexPath)
        } else if daySelected == "sunday" {
            customCell.configure(with: sunday[indexPath.row], time: time, indexPath: indexPath)
        }
        
    
        customCell.indexPathForCell = indexPath

        
        return customCell
    }
    
    // delete when slide
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
    }
    
    func sessionCompleted(indexPath: IndexPath){

        print(daySelected)
        if daySelected == "monday" {
            mondayCompleted[indexPath.row] = true
        } else if daySelected == "tuesday" {
            tuesdayCompleted[indexPath.row] = true
        } else if daySelected == "wednesday" {
            wednesdayCompleted[indexPath.row] = true
        } else if daySelected == "thursday" {
            thursdayCompleted[indexPath.row] = true
        } else if daySelected == "friday" {
            fridayCompleted[indexPath.row] = true
        } else if daySelected == "saturday" {
            saturdayCompleted[indexPath.row] = true
        } else if daySelected == "sunday" {
            sundayCompleted[indexPath.row] = true
        }
        
    }
    
    
}

// ************************************************* CALLENDAR *************************************************
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
            cell.selectedView.layer.borderWidth = 1
            cell.selectedView.layer.masksToBounds = true
            cell.selectedView.layer.cornerRadius = cell.selectedView.frame.width / 2
            cell.selectedView.clipsToBounds = true
                        
            cell.dateLabel.textColor = UIColor.white
            cell.selectedView.isHidden = false
            
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
            PlanVC.daySelected = daySelected
            
            //if selectedDays.contains(daySelected){
            tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .left)
            //}

        } else {
            cell.dateLabel.textColor = UIColor.white
            cell.selectedView.isHidden = true
            

        }
        
        
        

    }
    
    func configurePlanVC(){
        
        PlanVC.mondayCompleted = mondayCompleted
        PlanVC.tuesdayCompleted = tuesdayCompleted
        PlanVC.wednesdayCompleted = wednesdayCompleted
        PlanVC.thursdayCompleted = thursdayCompleted
        PlanVC.fridayCompleted = fridayCompleted
        PlanVC.saturdayCompleted = saturdayCompleted
        PlanVC.sundayCompleted = sundayCompleted
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    
    
    
    
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: myCustomCell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        
        myCustomCell.dateLabel.text = cellState.text
        
        return myCustomCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath)     {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        
    }

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
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
    

