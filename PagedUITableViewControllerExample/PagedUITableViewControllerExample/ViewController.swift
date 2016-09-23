//
//  ViewController.swift
//  PagedUITableViewControllerExample
//
//  Created by Sergio Garcia on 23/9/16.
//  Copyright © 2016 Sergio Garcia. All rights reserved.
//

import UIKit

class TableViewController: PagedUITableViewController {
    
    private var dataSource = [[User]]()
    private var currentRequest: NSURLSessionTask?
    
    override func viewDidLoad() {
        self.tableView.estimatedRowHeight = 55
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        self.tableView.registerNib(UINib(nibName: String(LoadingTableViewCell), bundle: nil), forCellReuseIdentifier: String(LoadingTableViewCell))
        self.tableView.registerNib(UINib(nibName: String(UserTableViewCell), bundle: nil), forCellReuseIdentifier: String(UserTableViewCell))
        self.pagedDataSource = self
        self.pagedDelegate = self
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.dataSource[indexPath.section].removeAtIndex(indexPath.row)
            self.pagedActionsDelegate.deleteItem(atIndexPath: indexPath)
        }
    }
    
    private func downloadUsers(page page: Int, onSuccess: (pageSize: Int, data: [AnyObject], totalItems: Int) -> (), onError: (delayTime: NSTimeInterval) -> ()) {
        currentRequest = User.users(page: page, onSuccess: onSuccess, onError: onError)
    }

    private func setImageFromUrl(urlImage: String, forImageView imageView: UIImageView) {
        if let url = NSURL(string: urlImage) {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
                guard let data = data where error == nil
                    else {
                        print(error?.localizedDescription)
                        return
                }
                let image = UIImage(data: data)
                dispatch_async(dispatch_get_main_queue(), {
                    imageView.image = image
                })
            }
            task.resume()
        }
    }
}

extension TableViewController: PagedUITableViewDataSource {
    
    func downloadData(page page: Int, onSuccess: (pageSize: Int, data: [AnyObject], totalItems: Int) -> (), onError: (delayTime: NSTimeInterval) -> ()) {
        self.downloadUsers(page: page, onSuccess: onSuccess, onError: onError)
    }
    
    func appendData(data: [AnyObject], forPage page: Int) {
        self.dataSource.append(data as? [User] ?? [])
    }
    
    func numberOfSectionsInPagedTableView(pagedTableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func pagedTableView(pagedTableView: UITableView, numberOfRowsInPagedSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func loadingCellForPagedTableView(pagedTableView: UITableView, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(String(LoadingTableViewCell), forIndexPath: indexPath) as! LoadingTableViewCell
    }
    
    func pagedTableView(pagedTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = dataSource[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(String(UserTableViewCell), forIndexPath: indexPath) as! UserTableViewCell
        
        self.setImageFromUrl(user.avatar, forImageView: cell.userImage)
        cell.userId.text = "id: \(user.userId)"
        cell.userFirstName.text = user.firstName.capitalizedString
        cell.userLastName.text = user.lastName.capitalizedString
        return cell
    }
}


extension TableViewController: PagedUITableViewDelegate {
    
    func resetDataSource() {
        dataSource.removeAll()
    }
    
    func cancelCurrentRequest() {
        if let currentRequest = currentRequest {
            currentRequest.cancel()
        }
    }
}
