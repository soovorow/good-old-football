//
//  CampaignViewController.swift
//  Good Old FootBall
//
//  Created by Dmitry Suvorov on 20/11/2018.
//  Copyright © 2018 Dmitry Suvorov. All rights reserved.
//

import UIKit

class CampaignViewController: ViewController {

    @IBOutlet weak var firstLineLabel: UILabel!
    @IBOutlet weak var secondLineLabel: UILabel!
    @IBOutlet var campaignProgressLabels: Array<UILabel>!
    
    var currentGame: Game?
    var CVcurrentGameType: gameType?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(currentGame!.campaignProgress)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if currentGame!.campaignProgress >= 9 {
            firstLineLabel.text = """
            YOU ARE THE CHAMPION
            OF THE YARD
            """
            secondLineLabel.text = "we are so proud of you!"
        }
        
        for (i, label) in self.campaignProgressLabels.enumerated() {
            if 9 - i == currentGame!.campaignProgress {
                label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            }
            if 9 - i < currentGame!.campaignProgress {
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: label.text!)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                
                label.attributedText = attributeString
                
                label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "campaignGame" {
            let gvc = segue.destination as! GameViewController
            gvc.GVcurrentGameType = CVcurrentGameType!
            print("pass to campaign-to-game")
            print(CVcurrentGameType!)
            gvc.currentGame = game
        }
    }
    
    @IBAction func playPressed(_ sender: Any) {
        CVcurrentGameType = .campaign
        performSegue(withIdentifier: "campaignGame", sender: nil)
    }
    
}
