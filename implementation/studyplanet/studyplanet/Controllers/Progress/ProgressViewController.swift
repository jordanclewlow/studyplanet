import UIKit
class ProgressViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let reuseIdentifier = "progressCell" // also enter this string as the cell identifier in the storyboard
    let shapeLayer = CAShapeLayer()
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var progressBar: ProgressBar!
    var countFired = 0 // keep track of current progress
    
    var stars : Int! // how many stars overall collected
    var progress : CGFloat = 0 //percentage to the next level
    var level = 0
    
    // colours
    // my colours
    var planetBlue = UIColor(red: 101/255.0, green: 182/255.0, blue: 252/255.0, alpha: 1)
    var planetYellow = UIColor(red:248/255.0,green:212/255.0,blue:90/255.0,alpha: 1)
    var planetRed = UIColor(red: 248/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)
    var planetGreen = UIColor(red: 21/255.0, green: 191/255.0, blue: 154/255.0, alpha: 1)
    
    // levels
    var levels = [0,100,250,375,500,700,1000,1300,1700,2200,3800,4700,5700]

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // handleTap()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        // timer
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in self.countFired += 1
           // print(self.countFired)
            DispatchQueue.main.async { [self] in
                self.progressBar.progress = progress //min(/*0.03*CGFloat*/(self.progress), 1) //animate to the current progress
                
                //level up
                if self.progressBar.progress >= 1 {
                    progress = 0
                    level += 1
                    levelLabel.text = "Level " + String(level)                    
                }
            }
            
        }
    }
    
    //animation NOT USED
    @objc private func handleTap(){
        print("attempting to animate stroke")
        progress += 0.1
        print(progress)
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        
        basicAnimation.duration = 5
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
    }
    
    
    // BADGES
    
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
