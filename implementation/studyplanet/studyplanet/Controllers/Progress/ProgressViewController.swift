import UIKit
class ProgressViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let defaults = UserDefaults.standard
    
    // identifier
    let reuseIdentifier = "progressCell" // also enter this string as the cell identifier in the storyboard
   
    // declar outlets
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var progressBar: ProgressBar!
    
    // instantiate variables
    var countFired = 0 // keep track of current progress
    var stars : Int! // how many stars overall collected
    var progress : CGFloat = 0.0 //percentage to the next level
    let shapeLayer = CAShapeLayer()
    var usersLevel = 0
    
    // my colours
    var planetBlue = UIColor(red: 101/255.0, green: 182/255.0, blue: 252/255.0, alpha: 1)
    var planetYellow = UIColor(red:248/255.0,green:212/255.0,blue:90/255.0,alpha: 1)
    var planetRed = UIColor(red: 248/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)
    var planetGreen = UIColor(red: 21/255.0, green: 191/255.0, blue: 154/255.0, alpha: 1)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // retrieve level
        usersLevel = defaults.integer(forKey: "level")
        
        // timer
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in self.countFired += 1
           // print(self.countFired)
            DispatchQueue.main.async { [self] in
                self.progressBar.progress = progress //min(/*0.03*CGFloat*/(self.progress), 1) //animate to the current progress
                self.usersLevel = defaults.integer(forKey: "level")
                self.levelLabel.text = "Level "+String(usersLevel)
            }
        }
    }
 
    
    // *******************        badges         ***********************************

    //how many
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    // cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "progressCell", for: indexPath as IndexPath) as! ProgressViewCell
        
       // cell.backgroundColor = UIColor.cyan // make cell more visible in our example project

        return cell
    }
    
    
}
