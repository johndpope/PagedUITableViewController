//
//  PagedUITableViewController.swift
//  
//
//  Created by Sergio Garcia on 9/9/16.
//  Copyright © 2016 Sergio Garcia. All rights reserved.
//

import UIKit

private extension UIViewController {
    
    func isVisible() -> Bool {
        return self.isViewLoaded() && self.view.window != nil
    }
    
    func delayMainQueue(delay:Double, actions:()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))),
                       dispatch_get_main_queue(), actions)
    }
}

private extension UITableView {
    
    private func deselectRowsCoordinated(transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        let selectedRows = self.indexPathsForSelectedRows
        for row in selectedRows ?? [] {
            self.deselectRowAtIndexPath(row, animated: true)
            transitionCoordinator?.notifyWhenInteractionEndsUsingBlock({ context in
                if (context.isCancelled()) {
                    self.selectRowAtIndexPath(row, animated: false, scrollPosition: .None)
                }
            })
        }
    }
}

extension PagedUITableViewController: PagedUITableViewActionsDelegate {
    
    func reloadData() {
        downloadNextDataPage(true)
    }
    
    func deleteItem(atIndexPath indexPath: NSIndexPath) {
        if let currentItems = data[indexPath.section] {
            data[indexPath.section] = currentItems - 1
            if data[indexPath.section] == 0 {
                data.removeValueForKey(indexPath.section)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            })
        }
    }
}



class PagedUITableViewController: UITableViewController {
    
    var pagedDelegate: PagedUITableViewDelegate?
    var pagedDataSource: PagedUITableViewDataSource?
    var pagedActionsDelegate: PagedUITableViewActionsDelegate!
    
    private var downloading = false
    private var currentPage = 0
    private var totalPages: Int?
    
    private var data = [Int: Int]()
    
    override func awakeFromNib() {
        pagedActionsDelegate = self
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadNextDataPage()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.reloadData), forControlEvents: .ValueChanged)
        if let refresh = self.refreshControl {
            self.tableView.addSubview(refresh)
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.deselectRowsCoordinated(self.transitionCoordinator())
    }
    
    private func downloadNextDataPage(resetDatasource: Bool = false) {
        if resetDatasource {
            pagedDelegate?.cancelCurrentRequest()
            downloading = false
            self.refreshControl?.beginRefreshing()
            currentPage = 0
            totalPages = nil
        }
        
        guard !downloading else {
            print("Download in progress.")
            return
        }
        
        currentPage += 1
        if let totalPages = totalPages {
            guard currentPage <= totalPages else {
                print("All pages downloaded.")
                return
            }
        }
        
        downloading = true
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
        downloadData()
    }
    
    private func downloadData() {
        pagedDataSource?.downloadData(page: currentPage, onSuccess: { (pageSize, data, totalItems) in
            if self.refreshControl?.refreshing ?? false {
                dispatch_async(dispatch_get_main_queue()) {
                    self.refreshControl?.endRefreshing()
                }
                self.data.removeAll()
                self.pagedDelegate?.resetDataSource()
            }
            self.pagedDataSource?.appendData(data, forPage: self.currentPage)
            if self.totalPages == nil {
                let total = Double(totalItems) / Double(pageSize)
                self.totalPages = Int(ceil(total))
            }
            
            self.data[self.currentPage - 1] = data.count
            self.downloading = false
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
            }, onError: { (delayTime) in
                if self.isVisible() {
                    self.delayMainQueue(delayTime, actions: {
                        self.downloadData()
                    })
                } else {
                    if self.refreshControl?.refreshing ?? false {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.refreshControl?.endRefreshing()
                        }
                    }
                    self.currentPage -= 1
                    self.downloading = false
                    self.tableView.reloadData()
                }
        })
    }
   
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if downloading {
            return data.count + 1
        } else {
            return data.count
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if downloading && section == data.count {
            // Loading cell
            return 1
        } else {
            return data[section] ?? 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if downloading && indexPath.section == data.count {
            // Loading cell
            return pagedDataSource?.loadingCellForPagedTableView(tableView, forIndexPath: indexPath) ?? UITableViewCell()
        } else {
            return pagedDataSource?.pagedTableView(tableView, cellForRowAtIndexPath: indexPath) ?? UITableViewCell()
        }
    }
    
    // MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == self.currentPage - 1 && self.currentPage < self.totalPages {
            downloadNextDataPage()
        }
    }
}
