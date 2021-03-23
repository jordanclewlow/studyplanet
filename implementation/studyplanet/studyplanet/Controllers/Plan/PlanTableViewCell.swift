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

    
    // my colours
    var planetBlue = UIColor(red: 101/255.0, green: 182/255.0, blue: 252/255.0, alpha: 1)
    var planetYellow = UIColor(red:248/255.0,green:212/255.0,blue:90/255.0,alpha: 1)
    var planetRed = UIColor(red: 248/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)
    var planetGreen = UIColor(red: 21/255.0, green: 191/255.0, blue: 154/255.0, alpha: 1)
    
    // outlets
    @IBOutlet weak var tickBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moduleLabel: UILabel!
    
    var completed : Bool!
    var hasBeenCompleted = false
    
    
    let currentTime = Calendar.current.component(.hour, from: Date())
    var revisionSlotTime = 0
    var currentDayNum = 0
    var dayOfTheWeekString = ""
    var selectedDayNum = 0
    var selectedDayOfTheWeekString = ""
    var indexPathForCell: IndexPath?
    static let identifier = "PlanTableViewCell"
    var days = ["monday","tuesday","wednesday","thursday","friday","saturday","sunday"]
    static func nib() -> UINib{
        return UINib(nibName: "PlanTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var backgroundCell: UIView!
    
    
    var stars : Int!
    
    let deselectImage = UIImage(named: "checkmark.circle")
    let selectImage = UIImage(named: "checkmark.circle.fill")
    

    
    
    @IBAction func clickedBtn(_ sender: UIButton) {
        if(!sender.isSelected){
            sessionCompleted(indexPath: indexPathForCell!, sender)
            
        }
    }
    
    func changeToGreen(){
        backgroundCell.backgroundColor = planetGreen
    }
    
    func giveStars(amount: Int) {
        let stars = delegate!.stars + amount
        defaults.setValue(stars, forKey: "stars")
    }
    
    // when you tick off a session
    func sessionCompleted(indexPath: IndexPath, _ sender: UIButton){
        let slotCompleted = true

        if(isItOnGoing()){ //
            let alert = UIAlertController(title: "Are you ready to start?", message: "You will earn 50 stars for starting this session on time.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] action in
                hasBeenCompleted = true
                if delegate?.daySelected == "monday" {
                    delegate?.mondayCompleted[indexPath.row] = true
                    defaults.setValue( delegate?.mondayCompleted, forKey: "mondayCompleted")
          

                } else if delegate?.daySelected == "tuesday" {
                    delegate?.tuesdayCompleted[indexPath.row] = true
                    defaults.setValue( delegate?.tuesdayCompleted, forKey: "tuesdayCompleted")

                } else if delegate?.daySelected == "wednesday" {
                    delegate?.wednesdayCompleted[indexPath.row] = true
                    defaults.setValue(delegate?.wednesdayCompleted, forKey: "wednesdayCompleted")

                } else if delegate?.daySelected == "thursday" {
                    delegate?.thursdayCompleted[indexPath.row] = true
                    defaults.setValue(delegate?.thursdayCompleted, forKey: "thursdayCompleted")

                } else if delegate?.daySelected == "friday" {
                    delegate?.fridayCompleted[indexPath.row] = true
                    defaults.setValue(delegate?.fridayCompleted, forKey: "fridayCompleted")

                } else if delegate?.daySelected == "saturday" {
                    delegate?.saturdayCompleted[indexPath.row] = true
                    defaults.setValue(delegate?.saturdayCompleted, forKey: "saturdayCompleted")

                } else if delegate?.daySelected == "sunday" {
                    delegate?.sundayCompleted[indexPath.row] = true
                    defaults.setValue(delegate?.sundayCompleted, forKey: "sundayCompleted")

                }
                sender.isSelected.toggle()
                tickBtn.layer.add(bounceAnimation, forKey: nil)
                
                backgroundCell.backgroundColor = planetGreen
                giveStars(amount: 250)
                                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [self] action in
                
                //completed = false
                
            }))
            
            delegate?.present(alert, animated: true)
            
        } else{
           
            let alert = UIAlertController(title: "Are you ready to start?", message: "You will earn 150 stars for starting this session early.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] action in
                if delegate?.daySelected == "monday" {
                    delegate?.mondayCompleted[indexPath.row] = true
                    defaults.setValue( delegate?.mondayCompleted, forKey: "mondayCompleted")
                

                } else if delegate?.daySelected == "tuesday" {
                    delegate?.tuesdayCompleted[indexPath.row] = true
                    defaults.setValue( delegate?.tuesdayCompleted, forKey: "tuesdayCompleted")

                } else if delegate?.daySelected == "wednesday" {
                    delegate?.wednesdayCompleted[indexPath.row] = true
                    defaults.setValue(delegate?.wednesdayCompleted, forKey: "wednesdayCompleted")

                } else if delegate?.daySelected == "thursday" {
                    delegate?.thursdayCompleted[indexPath.row] = true
                    defaults.setValue(delegate?.thursdayCompleted, forKey: "thursdayCompleted")

                } else if delegate?.daySelected == "friday" {
                    delegate?.fridayCompleted[indexPath.row] = true
                    defaults.setValue(delegate?.fridayCompleted, forKey: "fridayCompleted")

                } else if delegate?.daySelected == "saturday" {
                    delegate?.saturdayCompleted[indexPath.row] = true
                    defaults.setValue(delegate?.saturdayCompleted, forKey: "saturdayCompleted")

                } else if delegate?.daySelected == "sunday" {
                    delegate?.sundayCompleted[indexPath.row] = true
                    defaults.setValue(delegate?.sundayCompleted, forKey: "sundayCompleted")

                }
                
                backgroundCell.backgroundColor = planetGreen

                sender.isSelected.toggle()
                tickBtn.layer.add(bounceAnimation, forKey: nil)

                giveStars(amount: 150)
                
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { [self] action in
                completed = false
            }))
            
            delegate?.present(alert, animated: true)
            
        }
    }
    


    public func configure(with title:String, time:Int, indexPath: IndexPath, selectedDayNum: Int, selectedDayOfTheWeekString: String){
        timeLabel.text = String(time) + ":00"
        revisionSlotTime = time
                
        let strikeTitle: NSMutableAttributedString =  NSMutableAttributedString(string: title)
        strikeTitle.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, strikeTitle.length))
        
        let nonStrikeTitle: NSMutableAttributedString =  NSMutableAttributedString(string: title)
        moduleLabel.attributedText = nonStrikeTitle
        
        
        if(isItToday()){
            tickBtn.isHidden = false
            moduleLabel.textColor = UIColor.white
            timeLabel.textColor = UIColor.white
            
            // if it is later and not next (in next hour), make it white.
            if (isItLater() && !isItUpcoming()){
                
                
                //
                if(delegate?.daySelected == "monday"){
                    var completedSlotsArr = defaults.array(forKey: "mondayCompleted")
                    completedSlotsArr![indexPath.row] = false
                    defaults.setValue(completedSlotsArr, forKey: "mondayCompleted")
                    
                    
                    
                    
                    
                    
                } else if(delegate?.daySelected == "tuesday"){
                    
                    
                    var completedSlotsArr = defaults.array(forKey: "tuesdayCompleted" )as? [Bool] ?? [allFalseMondayCompleted]
                    if (completedSlotsArr != [] ){
                        print("completed slots arrr")

                        print(completedSlotsArr)

                        completedSlotsArr![indexPath.row] = false
                        defaults.setValue(completedSlotsArr, forKey: "tuesdayCompleted")
                    }
                    
                    
                } else if(delegate?.daySelected == "wednesday"){
                    var completedSlotsArr = defaults.array(forKey: "wednesdayCompleted")
                    completedSlotsArr![indexPath.row] = false
                    defaults.setValue(completedSlotsArr, forKey: "wednesdayCompleted")
                } else if(delegate?.daySelected == "thursday"){
                    var completedSlotsArr = defaults.array(forKey: "thursdayCompleted")
                    completedSlotsArr![indexPath.row] = false
                    defaults.setValue(completedSlotsArr, forKey: "thursdayCompleted")
                } else if(delegate?.daySelected == "friday"){
                    var completedSlotsArr = defaults.array(forKey: "fridayyCompleted")
                    completedSlotsArr![indexPath.row] = false
                    defaults.setValue(completedSlotsArr, forKey: "fridayCompleted")
                } else if(delegate?.daySelected == "saturday"){
                    var completedSlotsArr = defaults.array(forKey: "saturdayCompleted")
                    completedSlotsArr![indexPath.row] = false
                    defaults.setValue(completedSlotsArr, forKey: "mondayCompleted")
                } else if(delegate?.daySelected == "sunday"){
                    var completedSlotsArr = defaults.array(forKey: "sundayCompleted")
                    completedSlotsArr![indexPath.row] = false
                    defaults.setValue(completedSlotsArr, forKey: "sundayCompleted")
                }
            }
            
            
            
            
            
            
            
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
                moduleLabel.textColor = UIColor.white
                timeLabel.textColor = UIColor.white
                backgroundCell.backgroundColor = planetYellow
            }
            
            if(isItOnGoing() && !isItMissed()){  // if its on going make blue
                tickBtn.isHidden = false
                moduleLabel.textColor = UIColor.white
                timeLabel.textColor = UIColor.white
                backgroundCell.backgroundColor = planetBlue
            }
            
            // 
            if(!isItOnGoing() && !isItUpcoming()){ // if its not on going and not upcoming hide tick
                tickBtn.isHidden = true
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
         
            
        } else{ // not today
            moduleLabel.textColor = UIColor.white
            timeLabel.textColor = UIColor.white
            backgroundCell.backgroundColor = UIColor.darkGray
            tickBtn.isHidden = true
            
            // set to other days revision slots to not completed®
            if(delegate?.daySelected == "monday"){
                var completedSlotsArr = defaults.array(forKey: "mondayCompleted")
                completedSlotsArr![indexPath.row] = false
      
                defaults.setValue(completedSlotsArr, forKey: "mondayCompleted")
                
            } else if(delegate?.daySelected == "tuesday"){
                var completedSlotsArr = defaults.array(forKey: "tuesdayCompleted")
              
                completedSlotsArr![indexPath.row] = false
                defaults.setValue(completedSlotsArr, forKey: "tuesdayCompleted")
                
            } else if(delegate?.daySelected == "wednesday"){
                var completedSlotsArr = defaults.array(forKey: "wednesdayCompleted")
                completedSlotsArr![indexPath.row] = false
                defaults.setValue(completedSlotsArr, forKey: "wednesdayCompleted")
                
            } else if(delegate?.daySelected == "thursday"){
                var completedSlotsArr = defaults.array(forKey: "thursdayCompleted")
                completedSlotsArr![indexPath.row] = false
                defaults.setValue(completedSlotsArr, forKey: "thursdayCompleted")
                
            } else if(delegate?.daySelected == "friday"){
                var completedSlotsArr = defaults.array(forKey: "fridayyCompleted")
                completedSlotsArr![indexPath.row] = false
                defaults.setValue(completedSlotsArr, forKey: "fridayCompleted")
                
            } else if(delegate?.daySelected == "saturday"){
                var completedSlotsArr = defaults.array(forKey: "saturdayCompleted")
                completedSlotsArr![indexPath.row] = false
                defaults.setValue(completedSlotsArr, forKey: "saturdayCompleted")
                
            } else if(delegate?.daySelected == "sunday"){
                var completedSlotsArr = defaults.array(forKey: "sundayCompleted")
                completedSlotsArr![indexPath.row] = false
                defaults.setValue(completedSlotsArr, forKey: "sundayCompleted")
            }
        }
        
    }
    
    func isItToday() -> Bool {
        if(delegate?.daySelected == dayOfTheWeekString){ //if selected day is today
            return true
        } else {
            return false
        }
    }
    
    func isItLater() -> Bool {
        if(currentTime < revisionSlotTime){
            return true
        }
        return false
    }
    
    func isItOnGoing() -> Bool{
        if(currentTime >= revisionSlotTime && currentTime < revisionSlotTime+2){
            return true
        }
        return false
    }
    
    func isItPrevDay(time: Int) -> Bool{
        if(selectedDayNum < currentDayNum){
            return true
        }
        return false
    }
    
    func isItMissed() -> Bool{
        if(currentTime > revisionSlotTime){
            return true
        }
        return false
    }
    
    func isItUpcoming() -> Bool{ // is it 2 hours before a revision slot (between slots)
        if(isItToday()){
            if(revisionSlotTime > currentTime && revisionSlotTime <= currentTime+1) {
                return true
            }
        }
        return false
    }
   
    func isItValid(indexPath: IndexPath) -> Bool{
        if(((delegate?.mondayCompleted.count)!-1) < indexPath.row){
            return false
        }
        return true
    }
    

    func isItCompleted(indexPath: IndexPath) -> Bool{
        let sessionsCompletedOnDay = defaults.array(forKey: "mondayCompleted")

        if(delegate?.daySelected == "monday"){
            let sessionsCompletedOnDay = defaults.array(forKey: "mondayCompleted")

            if (sessionsCompletedOnDay![indexPath.row] as! Bool == true){
                return true
        } // if it is completed
            
            
            
            
        } else if(delegate?.daySelected == "tuesday"){
            let sessionsCompletedOnDay = defaults.array(forKey: "tuesdayCompleted")

            if (sessionsCompletedOnDay![indexPath.row] as! Bool == true){
                return true
            }// if it is completed
        } else if(delegate?.daySelected == "wednesday"){
            let sessionsCompletedOnDay = defaults.array(forKey: "tuesdayCompleted")

            if (sessionsCompletedOnDay![indexPath.row] as! Bool == true){
                return true
            } // if it is completed
        } else if(delegate?.daySelected == "thursday"){
            let sessionsCompletedOnDay = defaults.array(forKey: "thursdayCompleted")

            if (sessionsCompletedOnDay![indexPath.row] as! Bool == true){
                return true
            }// if it is completed
        } else if(delegate?.daySelected == "friday"){
            let sessionsCompletedOnDay = defaults.array(forKey: "fridayCompleted")

            if (sessionsCompletedOnDay![indexPath.row] as! Bool == true){
                return true
            }// if it is completed
        } else if(delegate?.daySelected == "saturday"){
            let sessionsCompletedOnDay = defaults.array(forKey: "saturdayCompleted")

            if (sessionsCompletedOnDay![indexPath.row] as! Bool == true){
                return true
            }
        } else if(delegate?.daySelected == "sunday"){
            let sessionsCompletedOnDay = defaults.array(forKey: "tuesdayCompleted")

            if (sessionsCompletedOnDay![indexPath.row] as! Bool == true){
                return true
            }
        
        }
        return false
    }

    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    self.layer.shadowColor = UIColor.lightGray.cgColor
    self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    self.layer.shadowOpacity = 1.0
    self.layer.shadowRadius = 0.0
  }
}

