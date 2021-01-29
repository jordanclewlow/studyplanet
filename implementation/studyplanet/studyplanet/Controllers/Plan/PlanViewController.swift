
//import frameworks
import UIKit
import JTAppleCalendar

class PlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var planTable: UITableView!
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let module = modules[indexPath.row]
        
       let customCell = tableView.dequeueReusableCell(withIdentifier: PlanTableViewCell.identifier, for: indexPath) as! PlanTableViewCell
            
        customCell.configure(with: module)
            
        return customCell
    }
    
    // instantiate variables
    var name : String! // users name
    var course : String! // users course
    var modules = [String]() // users modules
    var confidences = [Int]()
    var dailyStudyHours = 1 // default daily hours for study
    var selectedDays = [String]()
    
 
    
    let formatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        planTable.register(PlanTableViewCell.nib(), forCellReuseIdentifier: PlanTableViewCell.identifier)
        
        planTable.delegate = self
        planTable.dataSource = self
        
        // DUMMY
        name = "testname" // users name
        course = "testcourse" // users course
        
        modules = ["module1","module2","module3"]  // users modules
        confidences = [30,25,60]
        
        dailyStudyHours = 5 // default daily hours for study
        selectedDays = ["monday","wednesday","friday"]
        allocateHours()
        // Do any additional setup after loading the view.
    }

    //Calucate percentage based on given values
    public func calculatePercentage(value:Double,percentageVal:Double)->Double{
        let val = value * percentageVal
        return val / 100.0
    }
    
    func swapModulesAndConfidence() -> Dictionary<String,Int>{
        // create modules dictionary with module:confidence pairs
        let modulesDict = Dictionary(uniqueKeysWithValues: zip(modules, confidences))
        
        // sort modules desc confidence
        let modulesDescDict = modulesDict.sorted { $0.1 > $1.1 }
        
        // sort modules asc confidence
        let modulesAscDict = modulesDict.sorted { $0.1 < $1.1 }
        
        // instantiate sorted arrays
        var descValueArray = [Int]() // array of descending sorted values
        var ascKeyArray = [String]() // array of ascending sorted keys

        // make array of desc values
        for (key, value) in modulesDescDict{
            descValueArray.append(value)
        }
        
        // make array of desc keys
        for (key, value) in modulesAscDict{
            ascKeyArray.append(key)
        }

        // create new dictionary, swapping  modules of biggest to smallest
        let swappedModulesDict = Dictionary(uniqueKeysWithValues: zip(ascKeyArray, descValueArray))
        
        print(swappedModulesDict)
        return(swappedModulesDict)
    }

    func allocateHours() -> Dictionary<String,Double>{
        
        // create modules dictionary with module:confidence pairs
        let modulesDict = Dictionary(uniqueKeysWithValues: zip(modules, confidences))
        
        // sort modules desc confidence
        let modulesDescDict = modulesDict.sorted { $0.1 > $1.1 }
        
        // sort modules asc confidence
        let modulesAscDict = modulesDict.sorted { $0.1 < $1.1 }
        
        // instantiate sorted arrays
        var descValueArray = [Int]() // array of descending sorted values
        var ascKeyArray = [String]() // array of ascending sorted keys

        // make array of desc values
        for (key, value) in modulesDescDict{
            descValueArray.append(value)
        }
        
        // make array of desc keys
        for (key, value) in modulesAscDict{
            ascKeyArray.append(key)
        }

        // create new dictionary, swapping  modules of biggest to smallest
        let swappedModulesDict = Dictionary(uniqueKeysWithValues: zip(ascKeyArray, descValueArray))

        //find total weekly hours of study
        var weeklyStudyHours = dailyStudyHours * selectedDays.count
        
        // find minimum hours allocated to each module (by me)
        var minWeeklyStudyHoursForEachModule = (Double(weeklyStudyHours) / 10 )
        var minDailyStudyHoursForEachModule = minWeeklyStudyHoursForEachModule / Double(selectedDays.count)
        
        // find remaining hours of study that need to be allocated
        var hoursToBeAllocatedWeekly = Double(weeklyStudyHours) - (minWeeklyStudyHoursForEachModule * Double(modules.count))
        var hoursToBeAllocatedDaily = hoursToBeAllocatedWeekly / Double(selectedDays.count)
        
        // find sum of all confidence
        var sumConfidence = 0
        for module in modules
        {
            sumConfidence = sumConfidence + modulesDict[module]!
        }
       
        // find % of each modules confidence compared to sum of confidence
        // make array of confidence percentages
        var allocatedDailyHours = [Double]() // percentage of the total hours
        for module in modules
        {
            name = module
            let percentageOfConfidence = (Double(swappedModulesDict[name]!) / Double(sumConfidence)) * 100
            let hours = calculatePercentage(value: hoursToBeAllocatedDaily,percentageVal: percentageOfConfidence) + minDailyStudyHoursForEachModule
            allocatedDailyHours.append(hours)
        }
        
        // sort percentages in desc
        allocatedDailyHours.sort(by:>)
        
        // create new dictionary, with modules and swapped values as percentages
        let modulesWithDailyHoursDict = Dictionary(uniqueKeysWithValues: zip(ascKeyArray, allocatedDailyHours))
        
        
        return(modulesWithDailyHoursDict)
    }
    
}


extension PlanViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
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
        formatter.dateFormat = "dd MM yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "01 01 2020")!
        let endDate = formatter.date(from: "01 12 2020")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 1,
                                                 generateInDates: .forFirstMonthOnly,
                                                 generateOutDates: .off,
                                                 hasStrictBoundaries: false)
        return parameters
    }
    
}
