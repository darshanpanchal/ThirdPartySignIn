//
//  ViewController.swift
//  ThirdPartySignIn
//
//  Created by Darshan on 31/03/23.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //
        if GIDSignIn.sharedInstance.hasPreviousSignIn(){
            GIDSignIn.sharedInstance.restorePreviousSignIn(){ user,err  in
                debugPrint("Already Loggen In with \(user?.profile?.email ?? "")" )
            }
        }
    }
    //MARK: Google Login
    @IBAction func buttonGoogleLogInTapped(){
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
          guard error == nil else { return}

          guard let user = result?.user,let idToken = user.idToken?.tokenString else { return }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            debugPrint(credential)
            debugPrint(user.profile?.email ?? "")
        }
    }
    

}

    

