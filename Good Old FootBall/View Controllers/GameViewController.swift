//
//  GameViewController.swift
//  Good Old FootBall
//
//  Created by Dmitry Suvorov on 16/11/2018.
//  Copyright © 2018 Dmitry Suvorov. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit
import GameplayKit
import FacebookCore
import FBAudienceNetwork

class GameViewController: ViewController, FBInterstitialAdDelegate {

    var interstitialAd: FBInterstitialAd?
    
    var GVcurrentGameType: gameType?
    var currentGame: Game?
    
    var scene: GameScene?
    
    
    @IBOutlet weak var spriteKitView: SKView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "defeatView" {
            let vc = segue.destination as! DefeatViewController
            vc.DVcurrentGameType = GVcurrentGameType!
            vc.currentGame = currentGame
        }
        
        if segue.identifier == "victoryView" {
            let vc = segue.destination as! VictoryViewController
            vc.VVcurrentGameType = GVcurrentGameType!
            vc.currentGame = currentGame
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initiateInterstitialAd()
    }
    
    
    
    func initiateInterstitialAd() {
        self.interstitialAd = FBInterstitialAd.init(placementID: "359522121473193_359953328096739")
        self.interstitialAd?.delegate = self
        self.interstitialAd?.load()
    }
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        if interstitialAd.isAdValid {
            interstitialAd.show(fromRootViewController: self)
        } else {
            adComplete()
        }
    }
    
    func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
        adComplete()
        print("Ad failed to load")
    }
    
    func interstitialAdDidClose(_ interstitialAd: FBInterstitialAd) {
        adComplete()
    }
    
    func adComplete() {
         createScene()
    }
    
    
    
    
    
    func createScene() {
        logGameStartedEvent(type : "\(GVcurrentGameType!)")

        scene = GameScene(fileNamed: "GameScene")
        scene!.scaleMode = .aspectFill
        scene!.size = view.bounds.size
        scene!.currentGameType = GVcurrentGameType!
        scene!.gameViewController = self
        
        spriteKitView.presentScene(scene)
        spriteKitView.ignoresSiblingOrder = true
        spriteKitView.showsFPS = false
        spriteKitView.showsNodeCount = false
        
        print(GVcurrentGameType!)
    }
    
    func performVictory() {
        destructScene()
        print("perform victory")
        print(currentGame!.campaignProgress)
        print(currentGame!.tradingCards)
        print(GVcurrentGameType!)
        if GVcurrentGameType == .campaign {
            currentGame!.campaignProgress = currentGame!.campaignProgress + 1
            print(currentGame!.campaignProgress)
            currentGame!.tradingCards = currentGame!.tradingCards + currentGame!.campaignProgress * 2
            logAchievedLevelEvent(level: "\(currentGame!.campaignProgress)")
        } else {
            currentGame!.tradingCards += 1
        }
        currentGame!.save()
        print(currentGame!.campaignProgress)
        performSegue(withIdentifier: "victoryView", sender: Any?.self)
    }
    
    func performDefeat() {
        logGameDoneEvent(score : "\(scene!.score[.player]!) - \(scene!.score[.enemy]!)")
        destructScene()
        performSegue(withIdentifier: "defeatView", sender: Any?.self)
    }
    
    func dismissMatch() {
        destructScene()
        self.dismiss(animated: false, completion: nil)
    }

    func destructScene() {
        self.scene?.removeAllActions()
        self.scene?.removeAllChildren()
        self.scene = nil
    }
    
    
    
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/swift/appevents
     */
    func logAchievedLevelEvent(level : String) {
        let params : AppEvent.ParametersDictionary = [.level : level]
        let event = AppEvent(name: .achievedLevel, parameters: params)
        AppEventsLogger.log(event)
    }
    
    func logGameStartedEvent(type : String) {
        let params : AppEvent.ParametersDictionary = ["Type" : type]
        let event = AppEvent(name: "Game Started", parameters: params)
        AppEventsLogger.log(event)
    }
    
    func logGameDoneEvent(score : String) {
        let params : AppEvent.ParametersDictionary = ["Score" : score]
        let event = AppEvent(name: "Game Done", parameters: params)
        AppEventsLogger.log(event)
    }
}
