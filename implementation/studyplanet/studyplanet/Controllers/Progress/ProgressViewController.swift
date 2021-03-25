import UIKit
class ProgressViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var badgesCollectionView: UICollectionView!
    // identifier
    let reuseIdentifier = "progressCell" // also enter this string as the cell identifier in the storyboard
   
    // declar outlets
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var badgeOutlet: UIImageView!
    
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
                if(self.userLevel == 2 && !userBadges.contains("level2")){
                    userBadges.append("level2")
                } else if(self.userLevel >= 5 && !userBadges.contains("level5")){
                    userBadges.append("level5")
                } else if(self.userLevel >= 10 && !userBadges.contains("level10")){
                    userBadges.append("level10")
                } else if(self.userLevel >= 15 && !userBadges.contains("level15")){
                    userBadges.append("level15")
                } else if(self.userLevel >= 20 && !userBadges.contains("level20")){
                    userBadges.append("level20")
                } else if(self.userLevel >= 25 && !userBadges.contains("level25")){
                    userBadges.append("level25")
                } else if(self.streak > 2 && !userBadges.contains("streak2")){
                    userBadges.append("streak2")
                } else if(self.streak > 5 && !userBadges.contains("streak5")){
                    userBadges.append("streak5")
                } else if(self.streak > 10 && !userBadges.contains("streak10")){
                    userBadges.append("streak10")
                } else if(self.streak > 15 && !userBadges.contains("streak15")){
                    userBadges.append("streak15")
                } else if(self.streak > 20 && !userBadges.contains("streak20")){
                    userBadges.append("streak20")
                } else if(self.streak > 25 && !userBadges.contains("streak25")){
                    userBadges.append("streak25")
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
