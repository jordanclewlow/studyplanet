//
//  PlanViewCellTableViewCell.swift
//  studyplanet
//
//  Created by Jordan on 30/12/2020.
//

import UIKit


class PlanTableViewCell: UITableViewCell {
    
    var delegate: PlanViewController!
    let defaults = UserDefaults.standard

    // cet up custom cell
    static let identifier = "PlanTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "PlanTableViewCell", bundle: nil)
    }
    
    // my colours
    var planetBlue = UIColor(red: 101/255.0, green: 182/255.0, blue: 252/255.0, alpha: 1)
    var planetYellow = UIColor(red:248/255.0,green:212/255.0,blue:90/255.0,alpha: 1)
    var planetRed = UIColor(red: 248/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)
    var planetGreen = UIColor(red: 21/255.0, green: 191/255.0, blue: 154/255.0, alpha: 1)
    
    // outlets
    @IBOutlet weak var tickBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moduleLabel: UILabel!
    @IBOutlet weak var backgroundCell: UIView!

    
    
    // instantiate variables
    var currentTime = 15//Calendar.current.component(.hour, from: Date())// time right now
    var revisionSlotTime = 0 // time of revision slot cell
    var currentDayNum = 0 // aka 14  <- march
    var selectedDayNum = 0 // aka 14  <- march
    var dayOfTheWeekString = "" // "monday"
    var streak = 0 // player's streak
    var selectedDayOfTheWeekString = "" // "monday"
    var indexPathForCell: IndexPath? // index path of current cell
    var days = ["monday","tuesday","wednesday","thursday","friday","saturday","sunday"]

    var stars : Int! // to give them stars

    
    
    // *******************     buttons and actions     *************************

    @IBAction func clickedBtn(_ sender: UIButton) {
        if(!sender.isSelected){
            sessionCompleted(indexPath: indexPathForCell!, sender)
            
        }
    }
    
    
    // *******************     functions     *************************
    
    // change cell background to green
    func changeToGreen(){
        backgroundCell.backgroundColor = planetGreen
    }
    
    // award user with stars
    func giveStars(amount: Int) {
        let stars = delegate!.stars + amount
        defaults.setValue(stars, forKey: "stars")
    }
    
    // is cell today
    func isItToday() -> Bool {
        if(dayOfTheWeekString == delegate?.daySelected){ //if selected day is today
            return true
        } else {
            return false
        }
    }
    
    // is it past this time
    func isItLater() -> Bool {
        if(currentTime < revisionSlotTime){
            return true
        }
        return false
    }
    
    // is it earlier than this time
    func isItEarlier() -> Bool {
        if(currentTime > revisionSlotTime){
            return true
        }
        return false
    }
  
    
    // is it active
    func isItOnGoing() -> Bool{
        if(currentTime >= revisionSlotTime && currentTime < revisionSlotTime+2){
            return true
        }
        return false
    }
    
    // is it a previous day
    func isItPrevDay(time: Int) -> Bool{
        if(selectedDayNum < currentDayNum){
            return true
        }
        return false
    }
    
    // has slot been missed
    func isItMissed() -> Bool{
        if(currentTime > revisionSlotTime){
            return true
        }
        return false
    }
    
    func isPrevMissed() -> Bool{
        let indexPath = indexPathForCell?.row ?? 0
 
        if(indexPath>0){
            if(delegate?.daySelected  == "monday"){
                if(delegate?.mondayCompleted[indexPathForCell!.row-1] == false){
                    return true
                }
            } else if(delegate?.daySelected  == "tuesday"){
                if(delegate?.tuesdayCompleted[indexPathForCell!.row-1] == false){
                    return true
                }
            } else if(delegate?.daySelected  == "wednesday"){
                if(delegate?.wednesdayCompleted[indexPathForCell!.row-1] == false){
                    return true
                }
            }else if(delegate?.daySelected  == "thursday"){
                if(delegate?.thursdayCompleted[indexPathForCell!.row-1] == false){
                    print("prev missed")
                    return true
                }
            } else if(delegate?.daySelected  == "friday"){
                if(delegate?.fridayCompleted[indexPathForCell!.row-1] == false){
                    print("prev missed")
                    return true
                }
            } else if(delegate?.daySelected  == "saturday"){
                if(delegate?.saturdayCompleted[indexPathForCell!.row-1] == false){
                    print("prev missed")
                    return true
                }
            } else if(delegate?.daySelected  == "sunday"){
                if(delegate?.sundayCompleted[indexPathForCell!.row-1] == false){
                    print("prev missed")
                    return true
                }
            }
        }
        return false
    }
    
    // is it hour between slots
    func isItUpcoming() -> Bool{ // is it 2 hours before a revision slot (between slots)
        if(isItToday()){
            if(revisionSlotTime > currentTime && revisionSlotTime <= currentTime+1) {
                return true
            }
        }
        return false
    }
   

    
    // has slot already been completed
    func isItCompleted(indexPath: IndexPath) -> Bool{

        if(delegate?.daySelected == "monday"){
            // get their completed tasks
             var sessionsCompletedOnDay = defaults.array(forKey: "mondayCompleted")
     
             // if nothing saved in defaults, make false array
             if (sessionsCompletedOnDay == nil){
                 sessionsCompletedOnDay = delegate?.mondayCompleted
                 defaults.setValue(sessionsCompletedOnDay, forKey: "mondayCompleted")
             }
             // return true if the cell is already completed
             if (sessionsCompletedOnDay![indexPath.row] as! Bool == true){return true}
             
        } else if(delegate?.daySelected == "tuesday"){
            
           // get their completed tasks
            var sessionsCompletedOnDay = defaults.array(forKey: "tuesdayCompleted")
    
            // if nothing saved in defaults, make false array
            if (sessionsCompletedOnDay == nil){
                sessionsCompletedOnDay = delegate?.tuesdayCompleted
                defaults.setValue(sessionsCompletedOnDay, forKey: "tuesdayCompleted")
            }
            // return true if the cell is already completed
            if (sessionsCompletedOnDay![indexPath.row] as! Bool == true){return true}
            
        } else if(delegate?.daySelected == "wednesday"){
            // get their completed tasks
             var sessionsCompletedOnDay = defaults.array(forKey: "wednesdayCompleted")
     
             // if nothing saved in defaults, make false array
             if (sessionsCompletedOnDay == nil){
                 sessionsCompletedOnDay = delegate?.wednesdayCompleted
                 defaults.setValue(sessionsCompletedOnDay, forKey: "wednesdayCompleted")
             }
             // return true if the cell is already completed
             if (sessionsCompletedOnDay![indexPath.row] as! Bool == true){return true}
             
            
        } else if(delegate?.daySelected == "thursday"){
            // get their completed tasks
             var sessionsCompletedOnDay = defaults.array(forKey: "thursdayCompleted")

             // if nothing saved in defaults, make false array
             if (sessionsCompletedOnDay == nil){
                 sessionsCompletedOnDay = delegate?.thursdayCompleted
                 defaults.setValue(sessionsCompletedOnDay, forKey: "thursdayCompleted")
             }
            
            if (sessionsCompletedOnDay![indexPath.row] as! Bool == true){return true}
            
            
        } else if(delegate?.daySelected == "friday"){
            // get their completed tasks
             var sessionsCompletedOnDay = defaults.array(forKey: "fridayCompleted")
     
             // if nothing saved in defaults, make false array
             if (sessionsCompletedOnDay == nil){
                 sessionsCompletedOnDay = delegate?.fridayCompleted
                 defaults.setValue(sessionsCompletedOnDay, forKey: "fridayCompleted")
             }
             // return true if the cell is already completed
             if (sessionsCompletedOnDay![indexPath.row] as! Bool == true){return true}
             
            
        } else if(delegate?.daySelected == "saturday"){
            // get their completed tasks
             var sessionsCompletedOnDay = defaults.array(forKey: "saturdayCompleted")
     
             // if nothing saved in defaults, make false array
             if (sessionsCompletedOnDay == nil){
                 sessionsCompletedOnDay = delegate?.saturdayCompleted
                 defaults.setValue(sessionsCompletedOnDay, forKey: "saturdayCompleted")
             }
             // return true if the cell is already completed
             if (sessionsCompletedOnDay![indexPath.row] as! Bool == true){return true}
             
            
        } else if(delegate?.daySelected == "sunday"){
            // get their completed tasks
             var sessionsCompletedOnDay = defaults.array(forKey: "sundayCompleted")
     
             // if nothing saved in defaults, make false array
             if (sessionsCompletedOnDay == nil){
                 sessionsCompletedOnDay = delegate?.sundayCompleted
                 defaults.setValue(sessionsCompletedOnDay, forKey: "sundayCompleted")
             }
             // return true if the cell is already completed
             if (sessionsCompletedOnDay![indexPath.row] as! Bool == true){return true}
             
        }
        
        // return false if not completed
        return false
    }

    func showCompletedAlert(title: String, message: String, reward: Int ){
        let alert = UIAlertController(title: "Are you ready to start?", message: "You will earn " + String(reward) + " stars for starting this session on time.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] action in
            if delegate?.daySelected == "monday" {
                delegate?.mondayCompleted[indexPathForCell!.row] = true
                defaults.setValue( delegate?.mondayCompleted, forKey: "mondayCompleted")
            } else if delegate?.daySelected == "tuesday" {
                delegate?.tuesdayCompleted[indexPathForCell!.row] = true
                defaults.setValue( delegate?.tuesdayCompleted, forKey: "tuesdayCompleted")

            } else if delegate?.daySelected == "wednesday" {
                delegate?.wednesdayCompleted[indexPathForCell!.row] = true
                defaults.setValue(delegate?.wednesdayCompleted, forKey: "wednesdayCompleted")

            } else if delegate?.daySelected == "thursday" {
                delegate?.thursdayCompleted[indexPathForCell!.row] = true
                defaults.setValue(delegate?.thursdayCompleted, forKey: "thursdayCompleted")

            } else if delegate?.daySelected == "friday" {
                delegate?.fridayCompleted[indexPathForCell!.row] = true
                defaults.setValue(delegate?.fridayCompleted, forKey: "fridayCompleted")

            } else if delegate?.daySelected == "saturday" {
                delegate?.saturdayCompleted[indexPathForCell!.row] = true
                defaults.setValue(delegate?.saturdayCompleted, forKey: "saturdayCompleted")

            } else if delegate?.daySelected == "sunday" {
                delegate?.sundayCompleted[indexPathForCell!.row] = true
                defaults.setValue(delegate?.sundayCompleted, forKey: "sundayCompleted")

            }
            tickBtn.isSelected.toggle()
            tickBtn.layer.add(bounceAnimation, forKey: nil)
            backgroundCell.backgroundColor = planetGreen
            giveStars(amount: reward)
            
            // streaks
            let streak = defaults.integer(forKey: "streak")
            defaults.setValue( streak+1, forKey: "streak")
            
            // for badges
            
                        
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [self] action in
        }))
        
        delegate?.present(alert, animated: true)
    }
    
    
    // when you tick off a session
    func sessionCompleted(indexPath: IndexPath, _ sender: UIButton){
  
        if(isItOnGoing()){ //
            showCompletedAlert(title: "Start session?", message: "You will earn 100 stars for completing the session on time", reward: 100)
        } else{
            showCompletedAlert(title: "Start session?", message: "You will earn 250 stars for completing the session on time", reward: 250)
        }
        
        
    }
    
    // configure the cell
    public func configure(with title:String, time:Int, indexPath: IndexPath, selectedDayNum: Int, selectedDayOfTheWeekString: String){
        indexPathForCell = indexPath
        // set up cell labels
        timeLabel.text = String(time) + ":00"
        revisionSlotTime = time
        let strikeTitle: NSMutableAttributedString =  NSMutableAttributedString(string: title)
        strikeTitle.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, strikeTitle.length))
        let nonStrikeTitle: NSMutableAttributedString =  NSMutableAttributedString(string: title)
        moduleLabel.attributedText = nonStrikeTitle
        

        if(isItToday()){ // is the cell today
            
            tickBtn.isHidden = false
            moduleLabel.textColor = UIColor.white
            timeLabel.textColor = UIColor.white
            
            // if it is later and not next (in next hour), make it white.
            if (isItLater() && !isItUpcoming()){
                if(delegate?.daySelected == "monday"){
                    var completedSlotsArr = defaults.array(forKey: "mondayCompleted") as? [Bool] ?? [Bool]()
                    if (completedSlotsArr != [] ){
                        if (completedSlotsArr.count < indexPath.row){
                            completedSlotsArr[indexPath.row] = false
                        }
                        defaults.setValue(completedSlotsArr, forKey: "mondayCompleted")
                    }
                    
                } else if(delegate?.daySelected == "tuesday"){
                    var completedSlotsArr = defaults.array(forKey: "tuesdayCompleted" )as? [Bool] ?? [Bool]()
                    if (completedSlotsArr != [] ){
                        if (completedSlotsArr.count < indexPath.row){
                            completedSlotsArr[indexPath.row] = false
                        }
                        defaults.setValue(completedSlotsArr, forKey: "tuesdayCompleted")
                    }
                    
                } else if(delegate?.daySelected == "wednesday"){
                    var completedSlotsArr = defaults.array(forKey: "wednesdayCompleted") as? [Bool] ?? [Bool]()
                    if (completedSlotsArr != [] ){
                        if (completedSlotsArr.count < indexPath.row){
                            completedSlotsArr[indexPath.row] = false
                        }
                        defaults.setValue(completedSlotsArr, forKey: "wednesdayCompleted")
                    }
                } else if(delegate?.daySelected == "thursday"){
                    var completedSlotsArr = defaults.array(forKey: "thursdayCompleted") as? [Bool] ?? [Bool]()
                    
    
                    if (completedSlotsArr != [] ){
                        
                        let numOfSlots = completedSlotsArr.count
                        let cellIndex = indexPath.row
                        
                        if (numOfSlots < cellIndex){
                            completedSlotsArr[indexPath.row] = false
                            
                        }
                        defaults.setValue(completedSlotsArr, forKey: "thursdayCompleted")
                    }
                    
                } else if(delegate?.daySelected == "friday"){
                    var completedSlotsArr = defaults.array(forKey: "fridayyCompleted") as? [Bool] ?? [Bool]()
                    if (completedSlotsArr != [] ){
                        if (completedSlotsArr.count < indexPath.row){
                            completedSlotsArr[indexPath.row] = false
                        }
                        defaults.setValue(completedSlotsArr, forKey: "fridayCompleted")
                    }
                } else if(delegate?.daySelected == "saturday"){
                    var completedSlotsArr = defaults.array(forKey: "saturdayCompleted") as? [Bool] ?? [Bool]()
                    if (completedSlotsArr != [] ){
                        if (completedSlotsArr.count < indexPath.row){
                            completedSlotsArr[indexPath.row] = false
                        }
                        defaults.setValue(completedSlotsArr, forKey: "mondayCompleted")
                    }
                } else if(delegate?.daySelected == "sunday"){
                    var completedSlotsArr = defaults.array(forKey: "sundayCompleted") as? [Bool] ?? [Bool]()
                    if (completedSlotsArr != [] ){
                        if (completedSlotsArr.count < indexPath.row){
                            completedSlotsArr[indexPath.row] = false
                        }
                        defaults.setValue(completedSlotsArr, forKey: "sundayCompleted")
                    }
                }
            }
            
            // if it is today and..
            
            if(isItMissed()){ // it is missed
                backgroundCell.backgroundColor = planetRed
                tickBtn.isHidden = true
                let strikeTitle: NSMutableAttributedString =  NSMutableAttributedString(string: title)
                strikeTitle.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, strikeTitle.length))
                moduleLabel.attributedText = strikeTitle

            } else if (!isItCompleted(indexPath: indexPath)){ // it isnt missed
                backgroundCell.backgroundColor = UIColor.white
                moduleLabel.textColor = UIColor.black
                timeLabel.textColor = UIColor.black
                moduleLabel.attributedText = nonStrikeTitle
            }
            
            if(!isItCompleted(indexPath: indexPath)) && isItUpcoming() {// make upcoming sessions yellow
                tickBtn.isHidden = false
                let upcomingTitle: NSMutableAttributedString =  NSMutableAttributedString(string: title + " (upcoming)")
              
                moduleLabel.attributedText = upcomingTitle
                
                moduleLabel.textColor = UIColor.white
                timeLabel.textColor = UIColor.white
                backgroundCell.backgroundColor = planetYellow
            }
            
            if(isItOnGoing() && !isItMissed()){  // if its on going make blue
                tickBtn.isHidden = false
                let nowTitle: NSMutableAttributedString =  NSMutableAttributedString(string: title + " (now!)")
              
                moduleLabel.attributedText = nowTitle
                moduleLabel.textColor = UIColor.white
                timeLabel.textColor = UIColor.white
                backgroundCell.backgroundColor = planetBlue
            }
            
            //
            if(!isItOnGoing() && !isItUpcoming()){ // if its not on going and not upcoming hide tick
                tickBtn.isHidden = true
            }
            

            if(isItOnGoing()){ // if current slot is not earlier than current time FIX FIX FIX
                if(isPrevMissed()){
                    //defaults.setValue(0, forKey: "streak")
                }
            }
            
            if(isItCompleted(indexPath: indexPath)){ // if it is today,completed
                backgroundCell.backgroundColor = planetGreen

                if(!tickBtn.isSelected){ // if not selected
                    tickBtn.isSelected.toggle() // select
                    backgroundCell.backgroundColor = planetGreen

                }
            } else { // if not completed
                if(tickBtn.isSelected){ // if selected
                    tickBtn.isSelected.toggle() // deselect
                }
            }
         
            // if it is not today
        } else{
            moduleLabel.textColor = UIColor.white
            timeLabel.textColor = UIColor.white
            backgroundCell.backgroundColor = UIColor.black
            tickBtn.isHidden = true
            
            // set to other days revision slots to not completed®
            if(delegate?.daySelected == "monday"){
                var completedSlotsArr = defaults.array(forKey: "mondayCompleted") as? [Bool] ?? delegate?.mondayCompleted
                completedSlotsArr![indexPath.row] = false
                defaults.setValue(completedSlotsArr, forKey: "mondayCompleted")
                
            } else if(delegate?.daySelected == "tuesday"){
                var completedSlotsArr = defaults.array(forKey: "tuesdayCompleted") as? [Bool] ?? delegate?.tuesdayCompleted
              
                completedSlotsArr![indexPath.row] = false
                defaults.setValue(completedSlotsArr, forKey: "tuesdayCompleted")
                
            } else if(delegate?.daySelected == "wednesday"){
                var completedSlotsArr = defaults.array(forKey: "wednesdayCompleted") as? [Bool] ?? delegate?.wednesdayCompleted
                completedSlotsArr![indexPath.row] = false
                defaults.setValue(completedSlotsArr, forKey: "wednesdayCompleted")
                
            } else if(delegate?.daySelected == "thursday"){
                var completedSlotsArr = defaults.array(forKey: "thursdayCompleted") as? [Bool] ?? delegate?.thursdayCompleted
                completedSlotsArr![indexPath.row] = false
                defaults.setValue(completedSlotsArr, forKey: "thursdayCompleted")
                
            } else if(delegate?.daySelected == "friday"){
                var completedSlotsArr = defaults.array(forKey: "fridayCompleted") as? [Bool] ?? delegate?.fridayCompleted
                completedSlotsArr![indexPath.row] = false
                defaults.setValue(completedSlotsArr, forKey: "fridayCompleted")
                
            } else if(delegate?.daySelected == "saturday"){
                var completedSlotsArr = defaults.array(forKey: "saturdayCompleted") as? [Bool] ?? delegate?.saturdayCompleted
                completedSlotsArr![indexPath.row] = false
                defaults.setValue(completedSlotsArr, forKey: "saturdayCompleted")
                
            } else if(delegate?.daySelected == "sunday"){
                var completedSlotsArr = defaults.array(forKey: "sundayCompleted") as? [Bool] ?? delegate?.sundayCompleted
                completedSlotsArr![indexPath.row] = false
                defaults.setValue(completedSlotsArr, forKey: "sundayCompleted")
            }
        }
        
    }
    
    // UI bounce animation
    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        streak = defaults.integer(forKey: "streak") 
        
        // ignore constraint erros
        defaults.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        //bbackgroundCell.backgroundColor = UIColor.white.cgColor
        backgroundCell.layer.cornerRadius = backgroundCell.frame.height / 2//2.3
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date)
        currentDayNum = components.day!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dayOfTheWeekString = dateFormatter.string(from: date).lowercased()
        

        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// **********************       extensions         **********************
extension UIView {
    func blink(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, alpha: CGFloat = 0.0) {
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.alpha = alpha
        })
    }
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
               value: NSUnderlineStyle.single.rawValue,
                   range:NSMakeRange(0,attributeString.length))
        return attributeString
    }
}

extension UIView {
  func setBottomBorder1() {
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    self.layer.shadowOpacity = 1.0
    self.layer.shadowRadius = 0.0
  }
}

