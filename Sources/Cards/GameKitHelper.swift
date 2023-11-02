//
//  GameKitHelper.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 20/12/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import GameKit
import Foundation

public let singleton = GameKitHelper()
public let PresentAuthenticationViewController =
"PresentAuthenticationViewController"

public protocol HasWindow {
    
    var window: UIWindow? { get }
}

public protocol GameKitHelperDelegate {
    func matchStarted()
    func matchEnded()
    func matchReceivedData(_ match: GKMatch, data: Data,
        fromPlayer player: String)
}


open class GameKitHelper: NSObject, GKGameCenterControllerDelegate, GKTurnBasedMatchmakerViewControllerDelegate {
    public var authenticationViewController: UIViewController?
    public var lastError: Error?
    public var delegate: GameKitHelperDelegate?
    public var multiplayerMatch: GKMatch?
    public var presentingViewController: UIViewController?
    public var multiplayerMatchStarted: Bool
    public var gameView : SKView?
    
    
    var onDismiss : () -> () = {}
    
    public class var sharedInstance: GameKitHelper {
        return singleton
    }
    
    override init() {
        multiplayerMatchStarted = false
        super.init()
    }
    
    
    public var displayName : String
        {
        
        if let name = gameCenterName, name != "Unknown"
        {
             return name
        }
    
        return "You".localize
      
       
    }
    public var gameCenterEnabled : Bool { return GKLocalPlayer.local.isAuthenticated }
    public var gameCenterName : String?
        {
        if  !gameCenterEnabled { return nil }
        
        let name = GKLocalPlayer.local.alias
        return name.truncated(18)
        }

    public func authenticateLocalPlayer () {
        
        //1
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = {(viewController, error) in
            
            
            //2
            self.lastError = error as NSError?
            
            if viewController != nil {
                //3
                self.authenticationViewController = viewController
                
                NotificationCenter.default.post(
                    name: Notification.Name(rawValue: PresentAuthenticationViewController),
                    object: self)
            }
        }
    }
    public func findMatch(_ minPlayers: Int, maxPlayers: Int,
        presentingViewController viewController: UIViewController,
        delegate: GameKitHelperDelegate) {
            
            //1
            if  !gameCenterEnabled{
                print("Local player is not authenticated")
                return
            }
            
            //2
            multiplayerMatchStarted = false
            multiplayerMatch = nil
            self.delegate = delegate
            presentingViewController = viewController
            
            
            //3
            let matchRequest = GKMatchRequest()
            matchRequest.minPlayers = minPlayers
            matchRequest.maxPlayers = maxPlayers
            
            //4
            let matchMakerViewController =
            GKTurnBasedMatchmakerViewController(matchRequest: matchRequest)
            
            matchMakerViewController.turnBasedMatchmakerDelegate = self
           
            matchMakerViewController.showExistingMatches = true;
            
            presentingViewController? .
                present(matchMakerViewController,
                    animated: false, completion: nil)
                
        
    }
    
   /// GKTurnBasedMatchmakerViewControllerDelegate functions START
        
        // The user has cancelled
        open func turnBasedMatchmakerViewControllerWasCancelled(_ viewController: GKTurnBasedMatchmakerViewController)
        {
             presentingViewController? .dismiss(animated: true, completion: nil)
              print("Matchmaker cancelled")
        }
        
        // Matchmaking has failed with an error
        open func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: Error)
        {
             presentingViewController? .dismiss(animated: true, completion: nil)
            print("Error finding match: %@", error.localizedDescription)
        }
    
    /*
        // Deprecated
        @available(iOS, introduced=5.0, deprecated=9.0, message="use GKTurnBasedEventListener player:receivedTurnEventForMatch:didBecomeActive:")
        optional public func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController, didFindMatch match: GKTurnBasedMatch)
    {
    }
        
        // Deprectated
        @available(iOS, introduced=5.0, deprecated=9.0, message="use GKTurnBasedEventListener player:wantsToQuitMatch:")
        optional public func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController, playerQuitForMatch match: GKTurnBasedMatch)
    {
    }

    */
    
    /// GKTurnBasedMatchmakerViewControllerDelegate functions END
    
    
    public func reportAchievement(_ achievement: Achievement)
      {
        reportAchievements([achievement])
    }
    public func reportAchievements(_ achievements: [Achievement]) {
  
        let gkAchievements : [GKAchievement] = achievements.map {
            ricketyKateAchievement in
            let gkAchievement = GKAchievement(identifier: ricketyKateAchievement.rawValue)
            gkAchievement.percentComplete = 100
            gkAchievement.showsCompletionBanner = true
            
            return gkAchievement as GKAchievement
        }
   
        
        if !gameCenterEnabled {
            print("Local player is not authenticated")
            return
        }
        GKAchievement.report(gkAchievements, withCompletionHandler: {(error) in
            self.lastError = error
        }) 
    }
 
    public func reportScore(_ score: Int64,
        forLeaderBoard leaderBoard: LeaderBoard) {
            
            if !gameCenterEnabled {
                print("Local player is not authenticated")
                return
            }
            
            //1
            let scoreReporter =
            GKScore(leaderboardIdentifier: leaderBoard.rawValue)
            scoreReporter.value = score
            scoreReporter.context = 0
            
            let scores = [scoreReporter]
            
            //2
            GKScore.report(scores, withCompletionHandler: {(error) in
                self.lastError = error
            }) 
    }
    public func showGKGameCenterViewController(_ viewController: UIViewController!, onDismiss : @escaping () -> ()) {
        
        
        self.onDismiss = onDismiss
        
        if !gameCenterEnabled {
            print("Local player is not authenticated")
            return
        }
        
        //1
        let gameCenterViewController = GKGameCenterViewController()
        
        //2
        gameCenterViewController.gameCenterDelegate = self
        
        //3
        gameCenterViewController.viewState = .achievements
        
        //4
        viewController .
            present(gameCenterViewController,
                animated: true, completion: nil)
    }
    
    open func gameCenterViewControllerDidFinish(_ gameCenterViewController:
        GKGameCenterViewController) {
            
            self.onDismiss()
            gameCenterViewController .
                dismiss(animated: true, completion: nil)
    }
   
}
