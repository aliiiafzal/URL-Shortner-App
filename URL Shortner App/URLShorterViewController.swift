
//
//  URLShorterViewController.swift
//  URL Shortner App
//
//  Created by Ali Afzal on 15/09/2022.
//

import UIKit
import CoreData

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var shorterUrl: UILabel?
    @IBOutlet weak var originalUrl: UILabel?
}

class URLShorterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    private var urlData = [UrlData]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    @IBOutlet weak var shortenButton: UIButton!
    @IBOutlet weak var linkTableView: UITableView!
    @IBOutlet weak var urlInput: UITextField!
    var name: String = ""
    var urltext: String?
    //private var data = [UrlData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        fetchEnteries()
        loadUrls()
    }
    
    func fetchEnteries() {
        shortenButton.layer.cornerRadius = 5
        urlInput.layer.cornerRadius = 5
        linkTableView.separatorColor = UIColor.clear
        if urltext != nil {
            linkTableView.dataSource = self
            linkTableView.delegate = self
            getData(urlName: urltext!)
//                        getData(urlName: urltext!, onCompletion: { result in
//                            let newUrl = UrlData(context: self.context)
//                            newUrl.short_link = result["short_link"]
//                            newUrl.original_link = result["original_link"]
//                            self.urlData.append(newUrl)
//                            self.saveUrl()
//                        })
        }
    }
    
    @IBAction func shorterPressed(_ sender: UIButton) {
        linkTableView.dataSource = self
        name  = urlInput.text!
        
        if name == "" {
            urlInput.text = "Please add a link here"
            urlInput.textColor = UIColor.red
            urlInput.layer.borderColor = UIColor.red.cgColor
            urlInput.layer.borderWidth = 1.5
            urlInput.resignFirstResponder()
        }
        
        else if isValidUrl(url: name) {
            getData(urlName: name)
//                        getData(urlName: name, onCompletion: { result in
//                            let newUrl = UrlData(context: self.context)
//                            newUrl.short_link = result["short_link"]
//                            newUrl.original_link = result["original_link"]
//                            self.urlData.append(newUrl)
//                            self.saveUrl()
//                        })
        }
    }
    
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
    
    @IBAction func touchedInputField(_ sender: UITextField) {
        if urlInput.text == "Please add a link here"
        {
            urlInput.text = ""
            urlInput.textColor = UIColor.black
            urlInput.layer.borderColor = UIColor.clear.cgColor
            urlInput.layer.borderWidth = 0.0
        }
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: linkTableView)
        guard let indexPath = linkTableView.indexPathForRow(at: point)
        else {
            return
        }
        context.delete(urlData[indexPath.section])
        saveUrl()
        urlData.remove(at: indexPath.section)
        linkTableView.beginUpdates()
        let indexSet = IndexSet(arrayLiteral: indexPath.section)
        linkTableView.deleteSections(indexSet, with: .left)
        linkTableView.endUpdates()
    }
    
    @IBAction func copyPressed(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: linkTableView)
        guard let indexPath = linkTableView.indexPathForRow(at: point)
        else {
            return
        }
        let cell = linkTableView.cellForRow(at: indexPath) as! TableViewCell
        UIPasteboard.general.string = cell.shorterUrl?.text
    }
    // , onCompletion: @escaping(Dictionary<String, String>) -> ()
    func getData(urlName:String)
    {
        let urlString = "https://api.shrtco.de/v2/shorten?url=" + urlName
        //print(urlString)
        if let url = URL(string : urlString){
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                if error == nil {
                    let httpResponse = response as! HTTPURLResponse
                    if httpResponse.statusCode == 201 {
                        let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        //print(jsonData!)
                        let result = jsonData as! Dictionary<String, Any>
                        //print(result)
                        //print(result["result"]!)
                        let task = result["result"] as! Dictionary<String, String>
                        //print(task["short_link"]!)
                        //print(task)
                        
//                        DispatchQueue.main.async {
//                                          onCompletion(task)
//                                      }
                        let newUrl = UrlData(context: self.context)
                        newUrl.short_link = task["short_link"]
                        newUrl.original_link = task["original_link"]
                        self.urlData.append(newUrl)
                        self.saveUrl()
                    }
                }
            }
            task.resume()
        }
        else
        {
            print("URL is not Correct")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return urlData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list = urlData[indexPath.section]
        let cell = linkTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.shorterUrl?.text = list.short_link
        cell.layer.cornerRadius = 8
        if let originalLink = list.original_link,
           let originalURL = URL.init(string: originalLink) {
            //print(originalURL.host)
            cell.originalUrl?.text = originalURL.host
        }
        return cell
    }
    
    func saveUrl() {
        do{
            try context.save()
        }
        catch {
            print("Error Saving Context \(error)")
        }
        DispatchQueue.main.async {
            self.linkTableView.reloadData()
        }
    }
    
    func loadUrls(with request: NSFetchRequest<UrlData> = UrlData.fetchRequest()) {
        do {
            urlData = try context.fetch(request)
        }
        catch {
            print("Error Fetching Data From Context \(error)")
        }
        linkTableView.reloadData()
    }
}

//struct ApiResponse {
//    let ok: Bool?
//    let result: UrlData
//}

//struct ApiResult: Decodable {
//    let original_link: String?
//    let short_link: String?
//}






