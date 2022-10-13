//
//  ViewController.swift
//  URL Shortner App
//
//  Created by Ali Afzal on 15/09/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var shortenButton: UIButton!
    @IBOutlet weak var urlInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlInput.layer.cornerRadius = 5
        shortenButton.layer.cornerRadius = 5
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func shortenPressed(_ sender: UIButton) {
        guard let storyboard = storyboard?.instantiateViewController(withIdentifier: "second_vc") as? URLShorterViewController else {
            return
        }
        storyboard.urltext = urlInput.text
        
        if storyboard.urltext == "" {
            urlInput.text = "Please add a link here"
            urlInput.textColor = UIColor.red
            urlInput.layer.borderColor = UIColor.red.cgColor
            urlInput.layer.borderWidth = 1.5
            urlInput.resignFirstResponder()
            
        }
        else if isValidUrl(url: storyboard.urltext!) {
            self.navigationController?.pushViewController(storyboard, animated: true)
        }
    }
    
    @IBAction func touchInputField(_ sender: UITextField) {
        if urlInput.text == "Please add a link here"
        {
            urlInput.text = ""
            urlInput.textColor = UIColor.black
            urlInput.layer.borderColor = UIColor.clear.cgColor
            urlInput.layer.borderWidth = 0.0
        }
    }
    
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
}

