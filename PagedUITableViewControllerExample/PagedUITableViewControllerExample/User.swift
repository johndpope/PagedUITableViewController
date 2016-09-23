//
//  User.swift
//
//
//  Created by Sergio Garcia on 23/9/16.
//  Copyright © 2016 Sergio Garcia. All rights reserved.
//

import UIKit

/*
 "page": "2",
 "per_page": 3,
 "total": 12,
 "total_pages": 4,
 "data": [
    {
        "id": 4,
        "first_name": "eve",
        "last_name": "holt",
        "avatar": "https://s3.amazonaws.com/uifaces/faces/twitter/marcoramires/128.jpg"
    }
 ]
 */
class User {
    let userId: Int
    let firstName: String
    let lastName: String
    let avatar: String
    
    init?(json: [String: AnyObject]) {
        guard let userId = json["id"] as? Int,
            let firstName = json["first_name"] as? String,
            let lastName = json["last_name"] as? String,
            let avatar = json["avatar"] as? String
            else {
                return nil
        }
        
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.avatar = avatar
    }
}

extension User {
    static func users(page page: Int, onSuccess: (pageSize: Int, data: [AnyObject], totalItems: Int) -> (), onError: (delayTime: NSTimeInterval) -> ()) -> NSURLSessionTask {
        let url = NSURL(string: "http://reqres.in/api/users?page=\(page)")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            guard let data = data
                else {
                onError(delayTime: 3)
                return
            }
            
            var users: [User] = []
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject],
                    pageSize = json["per_page"] as? Int,
                    totalPages = json["total_pages"] as? Int,
                    let usersJSON = json["data"] as? [[String: AnyObject]] {
                    for result in usersJSON {
                        if let user = User(json: result) {
                            users.append(user)
                        }
                    }
                    onSuccess(pageSize: pageSize, data: users, totalItems: totalPages * pageSize)
                } else {
                    onError(delayTime: 3)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
                onError(delayTime: 3)
            }
        }
        task.resume()
        return task
    }
}
