//
//  DashboardTypeCustomCollectionCell.swift
//  RibbonSample
//
//  Created by Rajesh Yadav on 14/09/18.
//  Copyright © 2018 RJ. All rights reserved.
//

import UIKit

class DashboardTypeCustomCollectionCell: UICollectionViewCell {
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgBg: UIImageView!
    @IBOutlet var imgPreview1: UIImageView!
    
    func displayContent(image: UIImage, title: String)
    {
        lblName.text = title
        imgPreview1.image = image
    }
}
