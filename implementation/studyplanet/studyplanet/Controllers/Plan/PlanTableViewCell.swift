//
//  PlanViewCellTableViewCell.swift
//  studyplanet
//
//  Created by Jordan on 30/12/2020.
//

import UIKit


class PlanTableViewCell: UITableViewCell {
    
    var delegate: PlanViewController!
    
    // my colours
    var planetBlue = UIColor(red: 101/255.0, green: 182/255.0, blue: 252/255.0, alpha: 1)
    var planetYellow = UIColor(red:248/255.0,green:212/255.0,blue:90/255.0,alpha: 1)
    var planetRed = UIColor(red: 248/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)
    var planetGreen = UIColor(red: 21/255.0, green: 191/255.0, blue: 154/255.0, alpha: 1)
    
    //@IBOutlet weak var completedBtn: UIButton!
    
    @IBOutlet weak var tickBtn: UIButton!
    

    let currentTime = 14      //Calendar.current.component(.hour, from: Date())
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
    
    @IBAction func planDoneBtn(_ sender: UIButton) {
    }
    
    var completed = false
    let deselectImage = UIImage(named: "checkmark.circle")
    let selectImage = UIImage(named: "checkmark.circle.fill")
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moduleLabel: UILabel!
    
    @IBAction func clickedBtn(_ sender: UIButton) {
        print(dayOfTheWeekString)
        if(!sender.isSelected){
            sessionCompleted(indexPath: indexPathForCell!, sender)
            
        }
    }
    
    func changeToGreen(){
        backgroundCell.backgroundColor = planetGreen
    }
    
    // when you tick off a session
    func sessionCompleted(indexPath: IndexPath, _ sender: UIButton){
        
        if(isItOnGoing()){ //
            let alert = UIAlertController(title: "Have you started this task?", message: "We will note you started your session on time.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] action in
                if delegate?.daySelected == "monday" {
                    delegate?.mondayCompleted[indexPath.row] = true
                } else if delegate?.daySelected == "tuesday" {
                    delegate?.tuesdayCompleted[indexPath.row] = true
                } else if delegate?.daySelected == "wednesday" {
                    delegate?.wednesdayCompleted[indexPath.row] = true
                } else if delegate?.daySelected == "thursday" {
                    delegate?.thursdayCompleted[indexPath.row] = true
                } else if delegate?.daySelected == "friday" {
                    delegate?.fridayCompleted[indexPath.row] = true
                } else if delegate?.daySelected == "saturday" {
                    delegate?.saturdayCompleted[indexPath.row] = true
                } else if delegate?.daySelected == "sunday" {
                    delegate?.sundayCompleted[indexPath.row] = true
                }
                sender.isSelected.toggle()
                tickBtn.layer.add(bounceAnimation, forKey: nil)
                
                backgroundCell.backgroundColor = planetGreen
                
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { [self] action in
                completed = false
            }))
            
            delegate?.present(alert, animated: true)
            
        } else{
            let alert = UIAlertController(title: "Have you started this task?", message: "Great! We will note you started your session earlier as this starts at " + String(revisionSlotTime) + ":00", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] action in
                if delegate?.daySelected == "monday" {
                    delegate?.mondayCompleted[indexPath.row] = true
                } else if delegate?.daySelected == "tuesday" {
                    delegate?.tuesdayCompleted[indexPath.row] = true
                } else if delegate?.daySelected == "wednesday" {
                    delegate?.wednesdayCompleted[indexPath.row] = true
                } else if delegate?.daySelected == "thursday" {
                    delegate?.thursdayCompleted[indexPath.row] = true
                } else if delegate?.daySelected == "friday" {
                    delegate?.fridayCompleted[indexPath.row] = true
                } else if delegate?.daySelected == "saturday" {
                    delegate?.saturdayCompleted[indexPath.row] = true
                } else if delegate?.daySelected == "sunday" {
                    delegate?.sundayCompleted[indexPath.row] = true
                }
                sender.isSelected.toggle()
                backgroundCell.backgroundColor = planetGreen
                
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
                backgroundCell.setBottomBorder1()
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

        }
        
    }
    
    func isItToday() -> Bool {
        if(delegate?.daySelected == dayOfTheWeekString){ //if selected day is today
            return true
        } else {
            return false
        }
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
   
    func isItCompleted(indexPath: IndexPath) -> Bool{
        if(delegate?.daySelected == "monday"){
            if (delegate?.mondayCompleted[indexPath.row] == true){return true} // if it is completed
        } else if(delegate?.daySelected == "tuesday"){
            if (delegate?.mondayCompleted[indexPath.row] == true){return true} // if it is completed
        } else if(delegate?.daySelected == "wednesday"){
            if (delegate?.wednesdayCompleted[indexPath.row] == true){return true} // if it is completed
        } else if(delegate?.daySelected == "thursday"){
            if (delegate?.thursdayCompleted[indexPath.row] == true){return true} // if it is completed
        } else if(delegate?.daySelected == "friday"){
            if (delegate?.fridayCompleted[indexPath.row] == true){return true} // if it is completed
        } else if(delegate?.daySelected == "saturday"){
            if (delegate?.saturdayCompleted[indexPath.row] == true){return true} // if it is completed
        } else if(delegate?.daySelected == "sunday"){
            if (delegate?.sundayCompleted[indexPath.row] == true){ return true}// if it is completed
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

