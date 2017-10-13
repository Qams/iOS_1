//
//  ViewController.swift
//  musicAlbum
//
//  Created by kamil on 13/10/2017.
//  Copyright © 2017 kamil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var album: [[String:Any]] = [];	
    
    override func viewDidLoad() {
        super.viewDidLoad()
        consumeJson()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBOutlet weak var getArtist: UITextField!
    @IBOutlet weak var getTitle: UITextField!
    @IBOutlet weak var getGenre: UITextField!
    @IBOutlet weak var getRelease: UITextField!
    @IBOutlet weak var getTracks: UITextField!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func consumeJson() {
        let todoEndpoint: String = "https://isebi.net/albums.php"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler:
            { (data: Data?, response: URLResponse?, error: Error?) in
                // this is where the completion handler code goes
                if let response = response {
                    print(response)
                }
                if let error = error {
                    print(error)
                }
                print("Data \(data)")
                do {
                    guard let albumJson = try JSONSerialization.jsonObject(with: data!, options: [])
                        as? [[String:Any]] else {
                            print("error trying to convert data to JSON")
                            return
                    }
                    // now we have the todo
                    // let's just print it to prove we can access it
                    self.album = albumJson
            
                    print("Album is: \(self.album)")
                    DispatchQueue.main.async {
                        self.getArtist.text = self.album[0]["artist"] as! String?
                        self.getTitle.text = self.album[0]["album"] as! String?
                        self.getGenre.text = self.album[0]["genre"] as! String?
                        let yearAlbum = self.album[0]["year"]!
                        let numTracks = self.album[0]["tracks"]!
                        self.getRelease.text = "\(yearAlbum)"
                        self.getTracks.text = "\(numTracks)"
                    }
                } catch  {
                    print("error trying to convert data to JSON")
                    return
                }
        })
        
        task.resume()
        
        
    }
}

