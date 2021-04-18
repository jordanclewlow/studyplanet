import UIKit
class ProgressViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var badgesCollectionView: UICollectionView!
    // identifier
    let reuseIdentifier = "progressCell" // also enter this string as the cell identifier in the storyboard
   
    // declare outlets
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var badgeOutlet: UIImageView!
    
    
    // badges
    var welcome : UIImage = UIImage(named:"world")!
    
    // levels
    var level2 : UIImage = UIImage(named:"level2")!
    var level5 : UIImage = UIImage(named:"level5")!
    var level10 : UIImage = UIImage(named:"level10")!
    var level15 : UIImage = UIImage(named:"level15")!
    var level20 : UIImage = UIImage(named:"level20")!
    var level25 : UIImage = UIImage(named:"level25")!
    
    // streaks
    var streak2 : UIImage = UIImage(named:"streak2")!
    var streak5 : UIImage = UIImage(named:"streak5")!
    var streak10 : UIImage = UIImage(named:"streak10")!
    var streak15 : UIImage = UIImage(named:"streak15")!
    var streak20 : UIImage = UIImage(named:"streak20")!
    var streak25 : UIImage = UIImage(named:"streak25")!

    
    
    // instantiate variables
    var countFired = 0 // keep track of current progress
    var stars : Int! // how many stars overall collected
    var progress : CGFloat = 0.0 //percentage to the next level
    let shapeLayer = CAShapeLayer()
    
    // users data
        var userLevel = 0
        var userBadges = [""]
        var streak = 0
    
    // my colours
    var planetBlue = UIColor(red: 101/255.0, green: 182/255.0, blue: 252/255.0, alpha: 1)
    var planetYellow = UIColor(red:248/255.0,green:212/255.0,blue:90/255.0,alpha: 1)
    var planetRed = UIColor(red: 248/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)
    var planetGreen = UIColor(red: 21/255.0, green: 191/255.0, blue: 154/255.0, alpha: 1)
    

    func showBadgeAlert(badgeTitle: String, badgeImage: UIImage){
        
        let alert = UIAlertController(title: "Congratulations!", message: "\nYou have just achieved the " + badgeTitle + " badge! \n", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler:nil)
        
        // add image to alert
        let imageView = UIImageView(frame: CGRect(x: 220, y: 15, width: 30, height: 30))
        imageView.image = badgeImage
        alert.view.addSubview(imageView)
    
        alert.addAction(action)
       
        present(alert, animated:true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ignore constraint errors
        defaults.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        defaults.set(false, forKey: "UICollectionViewFlowLayoutBreakForInvalidSizes")

        
        // retrieve level and badges
        userLevel = defaults.integer(forKey: "level")
        userBadges = defaults.value(forKey: "userBadges") as? [String] ?? [String]()

        // timer
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in self.countFired += 1
           // print(self.countFired)
            DispatchQueue.main.async { [self] in
                self.progressBar.progress = progress //min(/*0.03*CGFloat*/(self.progress), 1) //animate to the current progress
                
                
                self.userLevel = defaults.integer(forKey: "level")
                self.streak = defaults.integer(forKey: "streak")
                
                self.levelLabel.text = "Level "+String(userLevel)
                
                // give the right badges
                // if dont already have badge, show alert
                if(self.userLevel == 0 && !userBadges.contains("welcome")){
                    userBadges.append("welcome")
                    showBadgeAlert(badgeTitle: "Welcome", badgeImage: welcome)
                }else if(self.userLevel == 2 && !userBadges.contains("level2")){
                    userBadges.append("level2")
                    showBadgeAlert(badgeTitle: "Level 2", badgeImage: level2)
                } else if(self.userLevel >= 5 && !userBadges.contains("level5")){
                    userBadges.append("level5")
                    showBadgeAlert(badgeTitle: "Level 5", badgeImage: level5)
                } else if(self.userLevel >= 10 && !userBadges.contains("level10")){
                    userBadges.append("level10")
                    showBadgeAlert(badgeTitle: "Level 10", badgeImage: level10)
                } else if(self.userLevel >= 15 && !userBadges.contains("level15")){
                    userBadges.append("level15")
                    showBadgeAlert(badgeTitle: "Level 15", badgeImage: level15)
                } else if(self.userLevel >= 20 && !userBadges.contains("level20")){
                    userBadges.append("level20")
                    showBadgeAlert(badgeTitle: "Level 20", badgeImage: level20)
                } else if(self.userLevel >= 25 && !userBadges.contains("level25")){
                    userBadges.append("level25")
                    showBadgeAlert(badgeTitle: "Level 25", badgeImage: level25)
                } else if(self.streak > 2 && !userBadges.contains("streak2")){
                    userBadges.append("streak2")
                    showBadgeAlert(badgeTitle: "Streak 2", badgeImage: streak2)
                } else if(self.streak > 5 && !userBadges.contains("streak5")){
                    userBadges.append("streak5")
                    showBadgeAlert(badgeTitle: "Streak 5", badgeImage: streak5)
                } else if(self.streak > 10 && !userBadges.contains("streak10")){
                    userBadges.append("streak10")
                    showBadgeAlert(badgeTitle: "Streak 10", badgeImage: streak10)
                } else if(self.streak > 15 && !userBadges.contains("streak15")){
                    userBadges.append("streak15")
                    showBadgeAlert(badgeTitle: "Streak 15", badgeImage: streak15)
                } else if(self.streak > 20 && !userBadges.contains("streak20")){
                    userBadges.append("streak20")
                    showBadgeAlert(badgeTitle: "Streak 20", badgeImage: streak20)
                } else if(self.streak > 25 && !userBadges.contains("streak25")){
                    userBadges.append("streak25")
                    showBadgeAlert(badgeTitle: "Streak 25", badgeImage: streak25)
                }
                    
                defaults.setValue(userBadges, forKey: "userBadges")
                
                self.badgesCollectionView.reloadData()

            }
        }
    }
 
    
    // *******************        badges         ***********************************

    //how many
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userBadges.count
    }
    
    // cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "progressCell", for: indexPath as IndexPath) as! ProgressViewCell
        
        
        if userBadges.count != 0 {
            let badgeName = userBadges[indexPath.row]
            cell.configure(with: badgeName)

        }
        
       // cell.backgroundColor = UIColor.cyan // make cell more visible in our example project

        /*
         */
        
        
        return cell
    }
    
    
}
