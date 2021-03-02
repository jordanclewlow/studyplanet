
//import frameworks
import UIKit
import JTAppleCalendar

class PlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // instantiate outlets
    @IBOutlet weak var planTable: UITableView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
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
    var monday = [String]()
    var tuesday = [String]()
    var wednesday = [String]()
    var thursday = [String]()
    var friday = [String]()
    var saturday = [String]()
    var sunday = [String]()
    
    var daySelected = "monday"
    
    
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
        
        calendarView.scrollToDate(Date())
    }

    // Calculate percentage based on given values
    public func calculatePercentage(value:Double,percentageVal:Double)->Double{
        let val = value * percentageVal
        return val / 100.0
    }
    
    public func generateTimeTable(weeklyAllocatedHours: Dictionary<String,Double>) {
        var weeklyAllocated = weeklyAllocatedHours
        
        var timesDict = [Int:String]()
        
        var moduleCounter = [String:Int]()
        for module in modules{
            moduleCounter[module] = 0
        }
        
        var iterator = 0
        for day in selectedDays {
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
            
            let sortedKeys = Array(timesDict.values).sorted(by: <)
            if day == "monday" {
                monday.append(contentsOf: sortedKeys)
            } else if day == "tuesday" {
                tuesday.append(contentsOf: sortedKeys)
            } else if day == "wednesday" {
                wednesday.append(contentsOf: sortedKeys)
            } else if day == "thursday" {
                thursday.append(contentsOf: sortedKeys)
            } else if day == "friday" {
                friday.append(contentsOf: sortedKeys)
            } else if day == "saturday" {
                saturday.append(contentsOf: sortedKeys)
            } else if day == "sunday" {
                sunday.append(contentsOf: sortedKeys)
            }
            
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
    

    
    // table view to display timetable
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

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let customCell = tableView.dequeueReusableCell(withIdentifier: PlanTableViewCell.identifier, for: indexPath) as! PlanTableViewCell
       
        if daySelected == "monday" {
            customCell.configure(with: monday[indexPath.row])
        } else if daySelected == "tuesday" {
                customCell.configure(with: tuesday[indexPath.row])
        } else if daySelected == "wednesday" {
            customCell.configure(with: wednesday[indexPath.row])
        } else if daySelected == "thursday" {
            customCell.configure(with: thursday[indexPath.row])
        } else if daySelected == "friday" {
            customCell.configure(with: friday[indexPath.row])
        } else if daySelected == "saturday" {
            customCell.configure(with: saturday[indexPath.row])
        } else if daySelected == "sunday" {
            customCell.configure(with: sunday[indexPath.row])
        }
            
        return customCell
    }
    
}

// calendar
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
    
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        cell.dateLabel.isHidden = false
        if cellState.isSelected {
            cell.selectedView.layer.cornerRadius =  13
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
            
            //if selectedDays.contains(daySelected){
            tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .left)
            //}

        } else {
            cell.dateLabel.textColor = UIColor.black
            cell.selectedView.isHidden = true
            

        }
        
        
        

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
    

