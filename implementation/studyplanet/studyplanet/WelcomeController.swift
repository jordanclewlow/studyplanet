//
//  TellViewController.swift
//  moduletableproject
//
//  Created by Jordan on 28/12/2020.
//

import UIKit

class WelcomeViewController: UIViewController{
    
    // reference outlets test
    @IBOutlet weak var earth: UIImageView!
    
    // rotate earth image
    func rotateView(targetView: UIImageView, duration: Double = 1.0) {
        UIImageView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(M_PI))
        }) { [self] finished in
            self.rotateView(targetView: earth, duration: duration)
        }
    }

    override func viewDidLoad() {
        self.rotateView(targetView: earth, duration: 22)
    }
}
