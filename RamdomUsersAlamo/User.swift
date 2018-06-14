//
//  User.swift
//  RamdomUsers
//
//  Created by Daniel Lahoz on 14/6/18.
//  Copyright © 2018 Daniel Lahoz. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

/**
 "gender": "male",
 "name": {
     "title": "mr",
     "first": "manuel",
     "last": "warren"
 },
 "location": {
     "street": "6774 hickory creek dr",
     "city": "bendigo",
     "state": "victoria",
     "postcode": 3802
 },
 "email": "manuel.warren@example.com",
 "login": {
     "username": "smallpeacock876",
     "password": "dirt",
     "salt": "WR26R9Fi",
     "md5": "a71793ab4853f9d38ba9bd7872e90eba",
     "sha1": "c356bdf8079b520c2aa7be9a842ccbaf938a352e",
     "sha256": "47dc83999c6582219c124c2a6d1e0ff3aafdbe96c2c877ceefb9303a84381646"
 },
 "registered": 1194910217,
 "dob": 267473972,
 "phone": "01-3375-9523",
 "cell": "0438-332-798",
 "id": {
     "name": "TFN",
     "value": "441238660"
 },
 "picture": {
     "large": "https://randomuser.me/api/portraits/men/65.jpg",
     "medium": "https://randomuser.me/api/portraits/med/men/65.jpg",
     "thumbnail": "https://randomuser.me/api/portraits/thumb/men/65.jpg"
 },
 "nat": "AU"
 **/


protocol UserDelegate: class {
    func isDownloading(_ progress: Float, email: String)
}

class User : NSObject {

    weak var delegate:UserDelegate?
    
    var photoUrl: URL
    var favorite = false
    var name: String
    var surname: String
    var email: String
    var phone: String
    var street: String
    var city: String
    var state: String
    var postcode: String
    var registered: String
    var gender: String
    var fakelocation: CLLocation
    
    var fileTask: URLSessionDownloadTask?
    
    var image: UIImage? {
        get{
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("\(self.name)-\(self.surname)-\(self.registered).png")
            guard let data = try? Data(contentsOf: fileURL) else{
                return nil
            }
            let myImage =  UIImage(data: data)
            return myImage

        }
        set (newValue){
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsURL.appendingPathComponent("\(self.name)-\(self.surname)-\(self.registered).png")
                if let jpegImageData = UIImageJPEGRepresentation(newValue!, 1.0){
                    try? jpegImageData.write(to: fileURL, options: [])
                }
        }

    }
    
    //static let photoUrlKey = "photoUrl"
    //static let favoriteKey = "favorite"

    init(dictionary values: NSDictionary) {
        
        guard let media = values["picture"] as? NSDictionary,
          let urlString = media["thumbnail"] as? String, let url = URL(string: urlString) else {
          fatalError("User item could not be created: " + values.description)
        }
        photoUrl = url

        
        guard let namedicc = values["name"] as? NSDictionary,
            let first = namedicc["first"] as? String, let last = namedicc["last"] as? String else {
                fatalError("User item could not be created: " + values.description)
        }
        name = first
        surname = last
        
        guard let mail = values["email"] as? String else {
                fatalError("User item could not be created: " + values.description)
        }
        email = mail
        
        guard let aphone = values["phone"] as? String else {
            fatalError("User item could not be created: " + values.description)
        }
        phone = aphone
        
        guard let locdicc = values["location"] as? NSDictionary,
            let astreet = locdicc["street"] as? String, let acity = locdicc["city"] as? String,
            let astate = locdicc["state"] as? String else {
                fatalError("User item could not be created: " + values.description)
        }
        street = astreet
        city = acity
        state = astate
        
        guard let locdicc2 = values["location"] as? NSDictionary,
            let apostcode = locdicc2["postcode"]  else {
                fatalError("User item could not be created: " + values.description)
        }
        postcode = String(describing: apostcode)
        
        guard let aregistered = values["registered"] as? String else {
            fatalError("User item could not be created: " + values.description)
        }
        registered = aregistered
        
        guard let agender = values["gender"] as? String else {
            fatalError("User item could not be created: " + values.description)
        }
        gender = agender
        
        //Coordes similar to Madrid 40.4 , -3,7
        let ramdom = Double(arc4random_uniform(10000)) / 10000
        let latitud = (ramdom * 0.02) + 40.4
        let longitud = (ramdom * 0.02) - 3.7

        
        fakelocation = CLLocation(latitude: latitud, longitude: longitud)
        
    }
    
    
    func downloadFile() {
        /*
        fileTask?.cancel()
        
        let url = URL(string: "http://www.proyectos-simed.es/firmacorreo/DrUrbano.m4v")
        
        fileTask = NetworkClient.sharedInstance.getFileInBackground(url!) { [weak self] (file, progress, error) in
            guard error == nil else {
                return
            }
            
            guard progress != nil else {
                return
            }
            print("tarea: \(self!.photoUrl) nombre: \(self!.email) progreso:\(progress!)")
            
            guard self?.delegate != nil else {return}
            
            self!.delegate?.isDownloading(progress!, email: self!.email)
            
            guard file != nil else {
                return
            }
            
            
            
        }
 */
    }
    
    
    override var description : String {
        return "User \(name) \(surname) \(phone) \(email) \(photoUrl.absoluteString) \(String(describing: image?.size)) \n"
    }
}



// MARK: Equatable

func == (lhs: User, rhs: User) -> Bool {
    return lhs.email == rhs.email
}

