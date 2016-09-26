//
//  PostTableViewCell.swift
//  PagedUITableViewControllerExample
//
//  Created by Sergio Garcia on 23/9/16.
//  Copyright © 2016 Sergio Garcia. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var userFirstName: UILabel!
    @IBOutlet weak var userLastName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
