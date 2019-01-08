//
//  ViewController.swift
//  Good Old FootBall
//
//  Created by Dmitry Suvorov on 14/11/2018.
//  Copyright © 2018 Dmitry Suvorov. All rights reserved.
//

import UIKit

enum gameType {
    case easy
    case medium
    case hard
    case campaign
    case player2
}

class ViewController: UIViewController {
    
    var currentGameType:gameType = .medium
    var game:Game?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        game = Game.load()
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newGame" {
            let gvc = segue.destination as! GameViewController
            gvc.GVcurrentGameType = currentGameType
            gvc.currentGame = game
        }
        
        if segue.identifier == "campaignView" {
            let cvc = segue.destination as! CampaignViewController
            cvc.currentGame = game
        }
    }

    @IBAction func startPlayer2(_ sender: Any) {
        currentGameType = .player2
        performSegue(withIdentifier: "newGame", sender: nil)
    }
    
    @IBAction func startHard(_ sender: Any) {
        currentGameType = .hard
        performSegue(withIdentifier: "newGame", sender: nil)
    }

}

