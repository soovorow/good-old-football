//
//  VictoryViewController.swift
//  Good Old FootBall
//
//  Created by Dmitry Suvorov on 19/11/2018.
//  Copyright © 2018 Dmitry Suvorov. All rights reserved.
//

import UIKit

class VictoryViewController: ViewController {

    @IBOutlet weak var glowImgView: UIImageView!
    
    @IBOutlet weak var tapToCloseButton: UIButton!
    
    var VVcurrentGameType: gameType?
    var currentGame: Game?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Double.pi
        rotationAnimation.duration = 3
        rotationAnimation.repeatDuration = .infinity
        self.glowImgView.layer.add(rotationAnimation, forKey: nil)
        
        tapToCloseButton.isHidden = true
        UIView.animate(withDuration: 1, animations: {
            self.tapToCloseButton.isHidden = false
        }, completion:  nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "campaignView" {
            let gvc = segue.destination as! CampaignViewController
            gvc.CVcurrentGameType = VVcurrentGameType!
            gvc.currentGame = currentGame
        }
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        if VVcurrentGameType == .campaign {
            performSegue(withIdentifier: "campaignView", sender: Any?.self)
        } else {
            performSegue(withIdentifier: "mainView", sender: Any?.self)
        }
    }
}
