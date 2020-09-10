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
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var sigInFb: UIButton!
    @IBOutlet weak var signInGg: UIButton!
    
    var nameOfUser: String?
    var idOfUser: String?
    
    var userIDGoogle = ""
    var nameIDGoogle = ""
    
    var ref: DatabaseReference!
    
    var isLogined = UserDefaults.standard.integer(forKey: "option")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        GIDSignIn.sharedInstance()?.delegate = self
        
        if AccessToken.current != nil {
            firebaseFaceBookLogin(token: AccessToken.current!.tokenString)
        }
        
        autoLogin()
    }
    
    func autoLogin(){
        if isLogined != 0 {
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
                return
            }
            
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
                    
                    self.nameOfUser = picutreDic.object(forKey: "name") as? String
                    self.idOfUser = picutreDic.object(forKey: "id") as? String
                    
                    UserDefaults.standard.set(self.idOfUser, forKey: "idUser")
                    UserDefaults.standard.set(self.nameOfUser, forKey: "nameUserSession")
                    UserDefaults.standard.set(1, forKey: "option")
                    
                    self.nextToHomeViewController()
                }
            })
        }
    }
       
    func nextToHomeViewController(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tabBarVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// Huong
extension ViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            } else {
            }
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
            } else {
                let currentUser = GIDSignIn.sharedInstance()?.currentUser
                
                self.userIDGoogle = currentUser?.userID! as! String
                self.nameIDGoogle = currentUser?.profile.name! as! String
                UserDefaults.standard.set(self.userIDGoogle, forKey: "idUser")
                UserDefaults.standard.set(self.nameIDGoogle, forKey: "username")
                UserDefaults.standard.set(2, forKey: "option")
                
                self.nextToHomeViewController()
            }
            
        }
        
    }
    
}
