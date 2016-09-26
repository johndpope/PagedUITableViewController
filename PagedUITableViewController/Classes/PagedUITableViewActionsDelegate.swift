//
//  PagedUITableViewActionsDelegate.swift
//  
//
//  Created by Sergio Garcia on 13/9/16.
//  Copyright © 2016 Sergio Garcia. All rights reserved.
//

import Foundation

public protocol PagedUITableViewActionsDelegate {
    func reloadData()
    func deleteItem(atIndexPath indexPath: NSIndexPath)
}
