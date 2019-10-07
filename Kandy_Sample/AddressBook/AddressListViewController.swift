//
//  AddressListViewController.swift
//  RibbonSample
//
//  Created by Rajesh Yadav on 10/04/19.
//  Copyright © 2019 RJ. All rights reserved.
//

import UIKit
import CPaaSSDK

class AddressListViewController: BaseViewController, AddressBookDelegate {
    
    @IBOutlet weak var tblVw: UITableView!
    var arrayAddressbook = [AddressbookBO]()
    @IBOutlet weak var lblNoRecord: UILabel!
    
    var cpaas: CPaaS!
    var address_Handler = AddressBookModule()

    private var roundButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVw.register(UINib(nibName: "AddressListTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressListTableViewCell")
        //        self.lblNoRecord.isHidden = true
        
    }

    func fetchContactList(array: [AddressbookBO]) {
        arrayAddressbook = array
        self.tblVw.reloadData()
        LoaderClass.sharedInstance.hideOverlayView()
    }
    
    func deleteSingleContact(isSuccess: Bool) {
        if isSuccess{
            LoaderClass.sharedInstance.showActivityIndicator()
            address_Handler.fetchContactList()

        }else{
            Alert.instance.showAlert(msg: "Unable to delete Contact. Please try again later.", title: "", sender: self)
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        createFloatingButton()
        
        LoaderClass.sharedInstance.showActivityIndicator()
        address_Handler.cpaas = self.cpaas
        address_Handler.delegate_AddressBook = self
        address_Handler.fetchContactList()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if roundButton.superview != nil {
            self.roundButton.removeFromSuperview()
        }
    }
    
    func createFloatingButton() {
        roundButton = UIButton(type: .custom)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        roundButton.backgroundColor = .white
        // Make sure you replace the name of the image:
        roundButton.setImage(UIImage(named:"plus"), for: .normal)
        // Make sure to create a function and replace DOTHISONTAP with your own function:
        roundButton.addTarget(self, action: #selector(plusRoundButtonTapped(sender:)), for: UIControl.Event.touchUpInside)
        // We're manipulating the UI, must be on the main thread:
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(self.roundButton)
                NSLayoutConstraint.activate([
                    keyWindow.trailingAnchor.constraint(equalTo: self.roundButton.trailingAnchor, constant: 15),
                    keyWindow.bottomAnchor.constraint(equalTo: self.roundButton.bottomAnchor, constant: 15),
                    self.roundButton.widthAnchor.constraint(equalToConstant: 75),
                    self.roundButton.heightAnchor.constraint(equalToConstant: 75)])
            }
            // Make the button round:
            self.roundButton.layer.cornerRadius = 37.5
            // Add a black shadow:
            self.roundButton.layer.shadowColor = UIColor.black.cgColor
            self.roundButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            self.roundButton.layer.masksToBounds = false
            self.roundButton.layer.shadowRadius = 2.0
            self.roundButton.layer.shadowOpacity = 0.5
            // Add a pulsing animation to draw attention to button:
            let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.duration = 0.4
            scaleAnimation.repeatCount = .greatestFiniteMagnitude
            scaleAnimation.autoreverses = true
            scaleAnimation.fromValue = 1.0;
            scaleAnimation.toValue = 1.05;
            self.roundButton.layer.add(scaleAnimation, forKey: "scale")
        }
    }
    
    @objc func plusRoundButtonTapped(sender: UIButton) {
        let vc  = AddressbookViewController(nibName:"AddressbookViewController",bundle:nil)
//        vc.addressbook = model
        vc.isToUpdate = false
        vc.cpaas = self.cpaas
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


extension AddressListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressListTableViewCell", for: indexPath) as! AddressListTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let model = arrayAddressbook[indexPath.row]
        cell.lblName.text = model.firstName + " " + model.lastName
        cell.lblEmail.text = model.email
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if arrayScores.count>0{
        //            self.lblNoRecord.isHidden = true
        //        }else{
        //            self.lblNoRecord.isHidden = false
        //        }
        return arrayAddressbook.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = arrayAddressbook[indexPath.row]
        let vc  = AddressbookViewController(nibName:"AddressbookViewController",bundle:nil)
        vc.addressbook = model
        vc.isToUpdate = true
        vc.cpaas = self.cpaas
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let model = arrayAddressbook[indexPath.row]
            LoaderClass.sharedInstance.showActivityIndicator()
            
            let entity = CPContact(contactId: model.contactId)
            entity.email = model.email
            entity.firstName = model.firstName
            entity.lastName = model.lastName
            entity.buddy = model.isBuddy
            entity.homePhoneNumber = model.homePhoneNumber
            entity.businessPhoneNumber = model.businessPhoneNumber
            address_Handler.deleteSingleContact(contact: entity)
            
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}
