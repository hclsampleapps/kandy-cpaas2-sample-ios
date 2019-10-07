//
//  PresenceViewController.swift
//  RibbonSample
//
//  Created by Kunal Nagpal on 15/09/19.
//  Copyright © 2019 RJ. All rights reserved.
//

import UIKit
import CPaaSSDK

private let kCellIdentifier = "GroupCollectionCell"

class PresenceViewController: BaseViewController,PresenceProtocol {
    var cpaas: CPaaS!
    var presence_Handler = Persense_Handler()
    @IBOutlet weak var status_lbl: UILabel!
    @IBOutlet weak var status_pickerView: UIPickerView!
    @IBOutlet weak var status_imgView : UIImageView!
    let activityTypesArray = ["Available","Unknown", "Other", "Away", "Busy", "Lunch", "OnThePhone", "Vacation"]
    var prentiyList : CPPresentityList?
    var prenties = [CPPresentity]()
    
    
    @IBOutlet weak var groupCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarColorForViewController(viewController: self, type: 1, titleString: "Presence")
        presence_Handler.cpaas = self.cpaas
        presence_Handler.delegate = self;
        //status_pickerView.isHidden = true
        status_pickerView.delegate = self
        status_pickerView.dataSource = self
        // Do any additional setup after loading the view.
        presence_Handler.fetchAllPresentities()
        registerNib()
        
    }
    
    private func registerNib(){
        groupCollectionView.register(UINib(nibName: kCellIdentifier, bundle: nil), forCellWithReuseIdentifier: kCellIdentifier)
        groupCollectionView.delegate = self
        groupCollectionView.dataSource = self
        //groupCollectionView.isHidden = true
    }
    
    func updateUserStatus(status: String) {
        status_lbl.text = status
    }
    
    func updateUserStatusColor(status: String) {
        status_imgView.backgroundColor = GlobalFunctions.sharedInstance.getStatusColor(status: status)
    }
    
    @IBAction func updateStatus(_ sender: Any) {
        //status_pickerView.isHidden = false;
    }
    @IBAction func showGroups(_ sender: UIButton) {
        if sender.isSelected {
           // groupCollectionView.isHidden = true
        }else{
            //groupCollectionView.isHidden = false
        }
        sender.isSelected = !sender.isSelected
    }
    
    private func updateUserSelectedStatus(userStatus: String){
        //status_pickerView.isHidden = true
       // status_lbl.text = ""
        status_imgView.backgroundColor = GlobalFunctions.sharedInstance.getStatusColor(status: userStatus)
        presence_Handler.updateStatus(statusToUpdate: userStatus)
    }
    
     func listOfPresenties(list: Any) {
        prentiyList = list as? CPPresentityList
        if let aList  = prentiyList {
            prenties = Array(aList.presentities)
            groupCollectionView.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PresenceViewController : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return activityTypesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activityTypesArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateUserSelectedStatus(userStatus: activityTypesArray[row])
    }
    
}

extension PresenceViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let list = prentiyList {
            return list.presentities.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath) as! GroupCollectionCell
        if let _ = prentiyList {
            let prentity = prenties[indexPath.row] 
             aCell.configCell(name: prentity.userID, withStatus: prentity.activity.state.rawValue)
        }
       
        return aCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 30.0)
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
}
