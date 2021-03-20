import UIKit
class ProgressViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let reuseIdentifier = "progressCell" // also enter this string as the cell identifier in the storyboard
    let shapeLayer = CAShapeLayer()
    
    // colours
    // my colours
    var planetBlue = UIColor(red: 101/255.0, green: 182/255.0, blue: 252/255.0, alpha: 1)
    var planetYellow = UIColor(red:248/255.0,green:212/255.0,blue:90/255.0,alpha: 1)
    var planetRed = UIColor(red: 248/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)
    var planetGreen = UIColor(red: 21/255.0, green: 191/255.0, blue: 154/255.0, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // draw circle
       
        view.layer.addSublayer(shapeLayer)
        
        let center = view.center
        
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi, clockwise: true)
        
        
        /*trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = planetRed.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackLayer)*/
        
        
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = planetYellow.cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.strokeEnd = 0
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        view.layer.addSublayer(shapeLayer)
        
        handleTap()
    }
    
    @objc private func handleTap(){
        print("attempting to animate stroke")
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        
        basicAnimation.duration = 1
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "progressCell", for: indexPath as IndexPath) as! ProgressViewCell
        
       // cell.backgroundColor = UIColor.cyan // make cell more visible in our example project

        return cell
    }
    
    
}
