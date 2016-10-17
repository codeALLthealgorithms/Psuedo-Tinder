//
//  MatchesTableViewCell.swift
//  ParseStarterProject-Swift
//
//  Created by Shree Sampath on 7/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class MatchesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userIdLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var messagesLabel: UILabel!

    @IBOutlet weak var messageTextField: UITextField!
    
    @IBAction func send(_ sender: AnyObject) {
        
        print(userIdLabel.text)
        print(messageTextField.text)
        
        let message = PFObject(className: "Message")
        
        message["sender"] = PFUser.current()?.objectId!
        
        message["recipient"] = userIdLabel.text
        
        message["content"] = messageTextField.text
        
        message.saveInBackground()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
