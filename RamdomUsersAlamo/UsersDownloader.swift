//
//  UsersDownloader.swift
//  RamdomUsersAlmo
//
//  Created by Daniel Lahoz on 14/6/18.
//  Copyright © 2018 Daniel Lahoz. All rights reserved.
//

import Alamofire

enum UserServiceError: String, Error {
    case notImplemented = "This feature has not been implemented yet"
    case URLParsing = "Sorry, there was an error getting the photos"
    case JSONStructure = "Sorry, the photo service returned something different than expected"
}

typealias UserResult = ([User]?, Error?) -> Void

class UsersDownloader {
    
    func getAllFeedPhotos(_ completion: @escaping UserResult) {
        Alamofire.request("https://api.randomuser.me/?results=300").responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    if let dictionary = json as? [String : Any], let items = dictionary["results"] as? [NSDictionary] {
                        var photos = [User]()
                        for item in items {
                            photos.append(User(dictionary: item))
                        }
                        DispatchQueue.main.async {
                            completion(photos, nil)
                        }
                    }else{
                        DispatchQueue.main.async {
                            completion(nil, UserServiceError.JSONStructure)
                        }
                    }
                    
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    
}
