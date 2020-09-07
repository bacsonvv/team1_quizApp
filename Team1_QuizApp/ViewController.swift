//
//  ViewController.swift
//  Team1_QuizApp
//
//  Created by Vuong Vu Bac Son on 9/3/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//
import UIKit
import GoogleSignIn
import FirebaseAuth
import FBSDKLoginKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sigInFb: UIButton!
    
    @IBOutlet weak var signInGg: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        
        GIDSignIn.sharedInstance()?.delegate = self
    
        if AccessToken.current != nil {
            firebaseFaceBookLogin(token: AccessToken.current!.tokenString)
        }
        
    }
    
    func setupNavigation() {
         navigationController?.navigationBar.backgroundColor = .clear
         navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
         navigationController?.navigationBar.shadowImage = UIImage()
       }
      
    
    @IBAction func signInWithGG(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func signInWithFB(_ sender: Any) {
        facebookLogin()
        
    }
    
    func facebookLogin() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [Permission.publicProfile], viewController : self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Log in")
                self.returnUserData()
                
            }
        }
    }
    
    func firebaseFaceBookLogin(token:String)  {
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                print("Error Login")
                return
            }
            print("Login Done")
            if Auth.auth().currentUser != nil{
            }
        }
    }
    
    func returnUserData() {
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"email,name"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
            } else {
                let resultDic = result as! NSDictionary
                let name = resultDic.object(forKey: "name") as! String
                print("\(name)")
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
                vc.user = name
                //vc.tag = 0
                self.navigationController?.pushViewController(vc, animated: true)
                }
            
            })
    }
    
}
// Huong
extension ViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
                
            }
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                print("Error")
            } else {
                let email1 = user.profile.email
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
                vc.user = email1!
                //vc.tag = 1
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
    }
    
}
