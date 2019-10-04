//
//  DashboardViewController.swift
//  RibbonSample
//
//  Created by Rajesh Yadav on 26/03/19.
//  Copyright © 2019 RJ. All rights reserved.
//

import UIKit
import CPaaSSDK

class DashboardViewController: BaseViewController, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectioVw: UICollectionView!
    
    var mainContens = ["SMS", "Chat", "Voice/Video Call", "Addressbook"]
    let sourceNumber: String = "+19492657842"
    let destinationNumber: String = "+19492657843"
    var cpaas: CPaaS!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarColorForViewController(viewController: self, type: 0, titleString: "DASHBOARD")

        self.navigationItem.hidesBackButton = true
        let nibName = UINib(nibName: "DashboardTypeCustomCollectionCell", bundle: nil)
        self.collectioVw.register(nibName, forCellWithReuseIdentifier: "DashboardTypeCustomCollectionCell")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return mainContens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardTypeCustomCollectionCell", for: indexPath) as! DashboardTypeCustomCollectionCell
        
        let book = mainContens[indexPath.row]
        cell.displayContent(image: UIImage.init(named: "SMS")!, title: book)
        
        cell.imgBg.layer.borderColor = UIColor.lightGray.cgColor
        cell.imgBg.layer.borderWidth = 1.0
        cell.imgBg.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.imgBg.layer.shadowOpacity = 0.6
        cell.imgBg.layer.shadowRadius = 2.0
        cell.imgBg.layer.shadowColor = UIColor.red.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0{
            self.navigateToSMS()
        }
        else if indexPath.item == 1 {
            self.navigateToChat()
        }
        else if indexPath.item == 2 {
            self.navigateToVoiceVideo()
        }
        else if indexPath.item == 3 {
            self.navigateToAddressbook()
        }
        else if indexPath.item == 4 {
           self.navigateToPresence()
        }
        else{
            
        }
    }
}

extension DashboardViewController {
    
    //@objc(collectionView:layout:sizeForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize              = UIScreen.main.bounds
        let screenWidth             = screenSize.width - 20
        let cellSquareSize: CGFloat = (screenWidth / 2.0) //- 10 - 40
        
        return CGSize.init(width: cellSquareSize, height: 120.0)
    }
    
    //@objc(collectionView:layout:insetForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    //@objc(collectionView:layout:minimumLineSpacingForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    //@objc(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension DashboardViewController {
    
    func navigateToSMS() {
        let vc  = SMSViewController(nibName:"SMSViewController",bundle:nil)
        vc.cpaas = self.cpaas
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToChat() {
        let vc  = ChatViewController(nibName:"ChatViewController",bundle:nil)
        vc.cpaas = self.cpaas
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToAddressbook() {
        let vc  = AddressDirectoryViewController(nibName:"AddressDirectoryViewController",bundle:nil)
        vc.cpaas = self.cpaas
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToVoiceVideo() {
        let vc  = VoiceVideoViewController(nibName:"VoiceVideoViewController",bundle:nil)
        vc.cpaas = self.cpaas
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToPresence() {
        let vc  = VoiceVideoViewController(nibName:"VoiceVideoViewController",bundle:nil)
        vc.cpaas = self.cpaas
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
