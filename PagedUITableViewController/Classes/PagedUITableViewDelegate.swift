//
//  PagedUITableViewDelegate.swift
//  
//
//  Created by Sergio Garcia on 9/9/16.
//  Copyright © 2016 Sergio Garcia. All rights reserved.
//

import Foundation

protocol PagedUITableViewDelegate {
    func resetDataSource()
    func cancelCurrentRequest()
}
