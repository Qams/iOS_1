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
    var albumPtr: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        consumeJson()
        saveButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBOutlet weak var getArtist: UITextField!
    @IBOutlet weak var getTitle: UITextField!
    @IBOutlet weak var getGenre: UITextField!
    @IBOutlet weak var getRelease: UITextField!
    @IBOutlet weak var getTracks: UITextField!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func editArtist(_ sender: UITextField) {
        saveButton.isEnabled = true
    }
    
    @IBAction func editTitle(_ sender: UITextField) {
        saveButton.isEnabled = true
    }
    
    @IBAction func editGenre(_ sender: UITextField) {
        saveButton.isEnabled = true
    }
    
    @IBAction func editRelease(_ sender: UITextField) {
        saveButton.isEnabled = true
    }
    
    @IBAction func editTracks(_ sender: UITextField) {
        saveButton.isEnabled = true
    }
    
    @IBAction func toPreviousPage(_ sender: UIButton) {
        saveButton.isEnabled = false
        self.albumPtr = self.albumPtr - 1;
        if(albumPtr <= 0) {
            self.albumPtr = 0;
            previousButton.isEnabled = false;

        }
        updateFields()
    }
    @IBAction func toNextPage(_ sender: UIButton) {
        saveButton.isEnabled = false
        self.albumPtr = self.albumPtr + 1;
        if(albumPtr >= album.count) {
            if(albumPtr > album.count) {
                self.albumPtr = self.albumPtr - 1;
            }
            self.previousButton.isEnabled = true
            clearFields()
            if(album.count == 0){
                self.previousButton.isEnabled = false;
            }
        }
        else {
            self.previousButton.isEnabled = true;
            updateFields()
        }
    }
    
    @IBAction func toAddNew(_ sender: UIButton) {
        albumPtr = album.count;
        if(albumPtr > 0){
            self.previousButton.isEnabled = true
        }
        clearFields()
    }

    @IBAction func deleteAction(_ sender: UIButton) {
        if(album.count > 0) {
            if(albumPtr >= album.count)
            {
                clearFields()
            }
            else {
                album.remove(at: albumPtr)
                if(albumPtr < album.count){
                    updateFields()
                }
                else {
                    clearFields()
                }
            }
        }
    }
    
    @IBAction func toSaveNew(_ sender: UIButton) {
        if(checkIfNotEmpty()){
            if(albumPtr >= album.count){
                DispatchQueue.main.async {
                    var dict : [String: Any] = [:]
                    dict["artist"] = self.getArtist.text
                    dict["album"] = self.getTitle.text
                    dict["genre"] = self.getGenre.text
                    dict["year"] = self.getRelease.text
                    dict["tracks"] = self.getTracks.text
                    self.album.append(dict)
                }
            }
            else {
                self.album[albumPtr]["artist"] = self.getArtist.text
                self.album[albumPtr]["album"] = self.getTitle.text
                self.album[albumPtr]["genre"] = self.getGenre.text
                self.album[albumPtr]["year"] = self.getRelease.text
                self.album[albumPtr]["tracks"] = self.getTracks.text
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkIfNotEmpty() -> Bool {
        if((getArtist.text?.isEmpty)! && (getTitle.text?.isEmpty)! && (getGenre.text?.isEmpty)! && (getRelease.text?.isEmpty)! && (getTracks.text?.isEmpty)!) {
            return false
        }
        return true
    }
    
    func clearFields() {
        getArtist.text = ""
        getTitle.text = ""
        getGenre.text = ""
        getRelease.text = ""
        getTracks.text = ""
    }
    
    func updateFields() {
        self.getArtist.text = self.album[self.albumPtr]["artist"] as! String?
        self.getTitle.text = self.album[self.albumPtr]["album"] as! String?
        self.getGenre.text = self.album[self.albumPtr]["genre"] as! String?
        let yearAlbum = self.album[self.albumPtr]["year"]!
        let numTracks = self.album[self.albumPtr]["tracks"]!
        self.getRelease.text = "\(yearAlbum)"
        self.getTracks.text = "\(numTracks)"
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
                        self.previousButton.isEnabled = false
                    }
                } catch  {
                    print("error trying to convert data to JSON")
                    return
                }
        })
        
        task.resume()
        
        
    }
}

