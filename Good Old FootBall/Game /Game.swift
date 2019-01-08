//
//  Game.swift
//  Good Old FootBall
//
//  Created by Dmitry Suvorov on 20/11/2018.
//  Copyright © 2018 Dmitry Suvorov. All rights reserved.
//

import Foundation

class Game:Codable  {
    
    var campaignProgress = 0
    var tradingCards = 5
    
    var selectedTraining = "default"
    var purchasedTrainings:[String] = []
    
    var selectedBallSkin = "default"
    var purchasedBallSkins:[String] = []
    
    var selectedPlayerSkin = "default"
    var purchasedPlayerSkins:[String] = []
    
    var selectedFieldSkin = "default"
    var purchasedFieldSkins:[String] = []
    
    func save() {
        
        let propertyListEncoder = PropertyListEncoder()
        let encodedNote = try? propertyListEncoder.encode(self)
        try? encodedNote?.write(to: Game.getArchiveUrl(), options: .noFileProtection)
    }
    
    static func load() -> Game {
        
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedNoteData = try? Data(contentsOf: Game.getArchiveUrl()),
            let decodedNote = try? propertyListDecoder.decode(Game.self,
                                                              from: retrievedNoteData) {
            print(decodedNote)
            return decodedNote
        }
        
        print("NOTHING TO LOAD")
        return Game()
    }
    
    static func getArchiveUrl() -> URL {
        let documentsDirectory =
            FileManager.default.urls(for: .documentDirectory,
                                     in: .userDomainMask).first!
        let archiveURL =
            documentsDirectory.appendingPathComponent("game_progress")
                .appendingPathExtension("plist")
        
        return archiveURL
    }
}
