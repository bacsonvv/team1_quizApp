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
    
    var isLogined = UserDefaults.standard.integer(forKey: "option")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        
        GIDSignIn.sharedInstance()?.delegate = self
        
        if AccessToken.current != nil {
            firebaseFaceBookLogin(token: AccessToken.current!.tokenString)
        }
        
        autoLogin()
    }
    
    func setupNavigation() {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func autoLogin(){
        print(isLogined)
        if isLogined != 0 {
            print("Logged in")
            nextToHomeViewController()
        }
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
            case .success( _, _, _):
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
        if ((AccessToken.current) != nil) {
            
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
                
                // nếu không xảy ra lỗi
                if (error == nil){
                    
                    let dict = result as! [String : AnyObject]
                    
                    let picutreDic = dict as NSDictionary
                    
                    
                    let nameOfUser = picutreDic.object(forKey: "name") as! String
                    let idOfUser = picutreDic.object(forKey: "id") as! String
                    
                    
                    UserDefaults.standard.set(idOfUser, forKey: "idFB")
                    UserDefaults.standard.set(nameOfUser, forKey: "nameUserSession")
                    UserDefaults.standard.set(1, forKey: "option")
                    
                    self.nextToHomeViewController()
                    var tmpEmailAdd = ""
                    
                    if let emailAddress = picutreDic.object(forKey: "email") {
                        tmpEmailAdd = emailAddress as! String
                        print(tmpEmailAdd)
                    }
                    else {
                        var usrName = nameOfUser
                        usrName = usrName.replacingOccurrences(of: " ", with: "")
                        tmpEmailAdd = usrName+"@facebook.com"
                    }
                }
            })
        }
    }
    
    func nextToHomeViewController(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
                let currentUser = GIDSignIn.sharedInstance()?.currentUser
                
                let userIDGoogle = currentUser?.userID
                let nameIDGoogle = currentUser?.profile.name
                UserDefaults.standard.set(userIDGoogle, forKey: "idGG")
                UserDefaults.standard.set(nameIDGoogle, forKey: "nameUserSession")
                UserDefaults.standard.set(2, forKey: "option")
                
                self.nextToHomeViewController()
            }
            
        }
        
    }
    
}
