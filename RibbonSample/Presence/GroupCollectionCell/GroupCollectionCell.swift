//
//  GroupCollectionCell.swift
//  RibbonSample
//
//  Created by Kunal Nagpal on 15/09/19.
//  Copyright © 2019 RJ. All rights reserved.
//

import UIKit

class GroupCollectionCell: UICollectionViewCell {
    @IBOutlet weak var status_imageView: UIImageView!
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var status_lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
}
    private func setupUI(){
        status_imageView.layer.cornerRadius = status_imageView.frame.size.height/2
        status_imageView.backgroundColor = .green
        name_lbl.text = ""
        status_lbl.text = ""
    }
    
    func configCell(name: String, withStatus: String)  {
        if withStatus != "Available" {
            status_imageView.backgroundColor = .yellow
        }
        name_lbl.text = name
        status_lbl.text = withStatus
    }

}
