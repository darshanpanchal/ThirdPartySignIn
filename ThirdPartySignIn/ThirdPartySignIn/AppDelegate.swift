//
//  AppDelegate.swift
//  ThirdPartySignIn
//
//  Created by Darshan on 31/03/23.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import FBSDKLoginKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        //FaceBook
        ApplicationDelegate.shared.application(application,didFinishLaunchingWithOptions: launchOptions)
        
        //Create Google Sign In configuration object.
        let clientID = "693966664074-k9ln6gqr0t9mb6adtth1v6ikjho87fdj.apps.googleusercontent.com"
        let config = GIDConfiguration(clientID: "\(clientID)")
        GIDSignIn.sharedInstance.configuration = config
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
         let fblogin = ApplicationDelegate.shared.application(
                UIApplication.shared,
                open: url,
                sourceApplication: nil,
                annotation: [UIApplication.OpenURLOptionsKey.annotation]
         )
        if fblogin{
            return true
        }else{
            return GIDSignIn.sharedInstance.handle(url)
        }
    }


}

