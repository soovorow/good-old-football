//
//  DefeatViewController.swift
//  Good Old FootBall
//
//  Created by Dmitry Suvorov on 19/11/2018.
//  Copyright © 2018 Dmitry Suvorov. All rights reserved.
//

import UIKit

class DefeatViewController: ViewController {
    
    var DVcurrentGameType: gameType?
    var currentGame: Game?
    
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var quitButton: UIButton!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tryAgainButton.alpha = -1
        quitButton.alpha = -1
        UIView.animate(withDuration: 1, animations: {
            self.tryAgainButton.alpha = 1
            self.quitButton.alpha = 1
        }, completion:  nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tryAgain" {
            let gvc = segue.destination as! GameViewController
            gvc.GVcurrentGameType = DVcurrentGameType!
            gvc.currentGame = currentGame
        }
    }

    @IBAction func tryAgainPressed(_ sender: Any) {
        performSegue(withIdentifier: "tryAgain", sender: Any?.self)
    }
}
