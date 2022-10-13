//
//  LoginViewController.swift
//  URL Shortner App
//
//  Created by Ali Afzal on 13/10/2022.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
                if let e = error {
                    //print(e.localizedDescription)
                    let alert = UIAlertController(title: "Login", message: e.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    guard let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "Home_Vc") as? ViewController else {
                        return
                    }
                    self.navigationController?.pushViewController(storyboard, animated: true)
                }
            }
        }
    }
    
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        guard let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "Signup_Vc") as? SignupViewController else {
            return
        }
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
    
}
