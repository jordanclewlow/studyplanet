import UIKit
class ProgressViewCell: UICollectionViewCell {
    
    @IBOutlet weak var badge: UIImageView!
    
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

    
    public func configure(with badgeName: String) {
        if(badgeName == "welcome"){
            badge.image = welcome
        } else if (badgeName == "level2"){
            badge.image = level2
        } else if (badgeName == "level5"){
            badge.image = level5
        } else if (badgeName == "level10"){
            badge.image = level10
        } else if (badgeName == "level15"){
            badge.image = level15
        } else if (badgeName == "level20"){
            badge.image = level20
        } else if (badgeName == "level25"){
            badge.image = level25
        } else if (badgeName == "streak2"){
            badge.image = streak2
        } else if (badgeName == "streak5"){
            badge.image = streak5
        } else if (badgeName == "streak10"){
            badge.image = streak10
        } else if (badgeName == "streak15"){
            badge.image = streak15
        } else if (badgeName == "streak20"){
            badge.image = streak20
        } else if (badgeName == "streak25"){
            badge.image = streak25
        }
    }
    
}
