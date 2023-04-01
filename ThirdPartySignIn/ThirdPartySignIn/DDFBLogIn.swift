
import Foundation
import FBSDKLoginKit

final class DDFBLogIn:NSObject{
    
    //SingleTon Pattern
    static let shared = DDFBLogIn()
    private override init(){}
    //Manager
    private lazy var fbLoginManager:LoginManager = {
        return LoginManager()
    }()
    //Parameters
    private lazy var fbPermission = {
        ["fields":"id,name,first_name,last_name,gender,email,birthday,picture.type(large)"]
    }()
    //LogIn
    func logIn(completion:@escaping FBCompletion){
        self.getFaceBookInfo(completion: completion)
    }
    //LogOut
    private func logOut() {
        fbLoginManager.logOut()
        AccessToken.current = nil
    }
}
extension DDFBLogIn{
    
    //Completion
    typealias FBResult = Dictionary<String, AnyObject>
    typealias FBCompletion = (Result<FBResult?,Error>) -> Void
   
    //MARK Request
    private func getFaceBookInfo(completion: @escaping FBCompletion) -> Void {
        if AccessToken.current != nil {
            GraphRequest(graphPath: "/me", parameters: fbPermission, httpMethod: .get).start(){ (connection, result, error) in
                if error == nil,let fbresult:FBResult = result as? FBResult {
                    completion(.success(fbresult))
                } else {
                    if let error{
                        completion(.failure(error))
                    }
                }
            }
        } else {
            self.fbLoginManager.logIn(permissions: ["email", "public_profile"], from: nil, handler: {[weak self] (result, error) -> Void in
                if let error{
                    self?.logOut()
                    completion(.failure(error))
                } else if (result?.isCancelled)! {
                    self?.logOut()
                    if let error{
                        completion(.failure(error))
                    }
                } else {
                    GraphRequest(graphPath: "me", parameters: self?.fbPermission ?? [:]).start {(connection, result, error) -> Void in
                        if error == nil,let fbresult: FBResult = result as? FBResult {
                            completion(.success(fbresult))
                        } else {
                            if let error{
                                completion(.failure(error))
                            }
                        }
                    }
                }
            })
        }
    }
}

