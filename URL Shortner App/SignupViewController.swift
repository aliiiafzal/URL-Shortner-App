//
//  SignupViewController.swift
//  URL Shortner App
//
//  Created by Ali Afzal on 13/10/2022.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text
        {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    //print(e.localizedDescription)
                    let alert = UIAlertController(title: "Signup", message: e.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    guard let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "Home_Vc") as? ViewController else {
                        return
                    }
                    self.navigationController?.pushViewController(storyboard, animated: true)
                }
            }
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "Login_Vc") as? LoginViewController else {
            return
        }
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
}
