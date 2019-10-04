//
//  DirectoryTableViewCell.swift
//  RibbonSample
//
//  Created by Rajesh Yadav on 05/04/19.
//  Copyright © 2019 RJ. All rights reserved.
//

import UIKit

class DirectoryTableViewCell: UITableViewCell {
    
    @IBOutlet var imgBg: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblFirstName: UILabel!
    @IBOutlet var lblLastName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblUserId: UILabel!
    @IBOutlet var lblPhotoUrl: UILabel!
    @IBOutlet var imgBuddy: UIImageView!

    internal func displayContentType(object: DirectoryBO)
    {
        lblName.text = object.name
        lblFirstName.text = object.firstName
        lblLastName.text = object.lastName
        lblEmail.text = object.email
        lblUserId.text = object.userId
        lblPhotoUrl.text = object.photoUrl
        imgBuddy.image = object.isBuddy ? UIImage.init(named: "selected"):UIImage.init(named: "unSelected")

        imgBg.layer.borderWidth = 1.0
        imgBg.layer.borderColor = UIColor.lightGray.cgColor
        imgBg.layer.cornerRadius = 4.0
        imgBg.layer.masksToBounds = true
    }
    internal class func height() -> CGFloat {
        return 412
    }
 
}
