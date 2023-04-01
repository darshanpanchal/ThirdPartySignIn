//
//  ViewController.swift
//  ThirdPartySignIn
//
//  Created by Darshan on 31/03/23.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import AuthenticationServices

class ViewController: UIViewController {

    @IBOutlet weak var appleSignIn: AppleSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //
        self.checkForGoogleAlreadyLogIn()
      
        self.appleSignIn.addTarget(self, action: #selector(buttonAppleSignInTapped), for: .touchUpInside)
    }
 
    func checkForGoogleAlreadyLogIn(){
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
          guard error == nil else {return}
          guard let user = result?.user,let idToken = user.idToken?.tokenString else { return }
          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            debugPrint(credential)
            debugPrint(user.profile?.email ?? "")
        }
    }
    @IBAction func buttonFaceBookLoginTapped(){
        DDFBLogIn.shared.logIn(completion: { fbresult in
            switch fbresult{
                case .success(let result):
                    if let result{
                        debugPrint(result)
                    }
                case .failure(let error):
                    debugPrint(error)
            }
        })
    }
    @IBAction func buttonAppleSignInTapped(){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension ViewController:ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            debugPrint(email)
            self.checkforUsercredentialState(userID:userIdentifier)
        }
    }
    func checkforUsercredentialState(userID:String){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userID) {  (credentialState, error) in
             switch credentialState {
                case .authorized:
                    // The Apple ID credential is valid.
                    break
                case .revoked:
                    // The Apple ID credential is revoked.
                    break
                case .notFound:
                    // No credential was found, so show the sign-in UI.
                    print("Not Found")
                default:
                    break
             }
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    }
    
}
final class AppleSignInButton:ASAuthorizationAppleIDButton{
    
    required init?(coder: NSCoder) {
        super.init(authorizationButtonType: .signIn, authorizationButtonStyle: UIView().currentMode == .darkMode ? .white : .black)
    }
    func signInRequest(classValue:UIViewController){
      
    }
}
extension UIView{
     var currentMode:DeviceMode{
        self.traitCollection.userInterfaceStyle == .dark ? .darkMode : .lightMode
    }
    enum DeviceMode{
        case darkMode
        case lightMode
    }
}

