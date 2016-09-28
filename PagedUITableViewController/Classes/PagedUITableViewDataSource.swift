
//
//  PagedUITableViewDataSource.swift
//  
//
//  Created by Sergio Garcia on 9/9/16.
//  Copyright © 2016 Sergio Garcia. All rights reserved.
//

import UIKit

public protocol PagedUITableViewDataSource {
    func downloadData(offset offset: Int, onSuccess: (pageSize: Int, data: [AnyObject], totalItems: Int) -> (), onError: (delayTime: NSTimeInterval) -> ())
    func appendData(data: [AnyObject], forOffset offset: Int)
    
    func numberOfSectionsInPagedTableView(pagedTableView: UITableView) -> Int
    func pagedTableView(pagedTableView: UITableView, numberOfRowsInPagedSection section: Int) -> Int
    func loadingCellForPagedTableView(pagedTableView: UITableView, forIndexPath indexPath: NSIndexPath) -> UITableViewCell
    func pagedTableView(pagedTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
}
