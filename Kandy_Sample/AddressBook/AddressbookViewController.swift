//
//  AddressbookViewController.swift
//  RibbonSample
//
//  Created by Rajesh Yadav on 05/04/19.
//  Copyright © 2019 RJ. All rights reserved.
//

import UIKit
import CPaaSSDK

class AddressbookViewController: BaseViewController, AddressBookAddUpdateDelegate {
       
    @IBOutlet weak var tblVw: UITableView!
    var addressbook = AddressbookBO()
    @IBOutlet weak var lblNoRecord: UILabel!
    var isToUpdate: Bool = false
    @IBOutlet weak var btnAddUpdate: UIButton!


    var cpaas: CPaaS!
    var address_Handler = AddressBookModule()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarColorForViewController(viewController: self, type: 1, titleString: "")

        self.tblVw.register(UINib(nibName: "AddressbookTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressbookTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddressbookViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddressbookViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        address_Handler.cpaas = self.cpaas
        address_Handler.delegate_AddUpdateAddressBook = self

        if isToUpdate {
            btnAddUpdate.setTitle("UPDATE CONTACT", for: UIControl.State.normal)
        }else{
            btnAddUpdate.setTitle("ADD CONTACT", for: UIControl.State.normal)
        }
    }

    @IBAction func btnAddUpdateTapped(sender: UIButton){
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tblVw.cellForRow(at: indexPath) as! AddressbookTableViewCell
        
        let object = AddressbookBO()
        object.contactId = cell.txtContactId.text
        object.primaryContact = cell.txtPrimaryContact.text
        object.firstName = cell.txtFirstName.text
        object.lastName = cell.txtLastName.text
        object.email = cell.txtEmail.text
        object.homePhoneNumber = cell.txtHomePhoneNumber.text
        object.businessPhoneNumber = cell.txtBusinessPhoneNumber.text

        if isToUpdate {
            object.isBuddy = addressbook.isBuddy
            address_Handler.updateContact(model: object)
        }else{
            object.isBuddy = cell.btnBuddy.isSelected
            address_Handler.createContact(model: object)
        }
    }
    
    func addedContact(isSuccess: Bool){
        if isSuccess{
            LoaderClass.sharedInstance.showActivityIndicator()
            self.navigationController?.popViewController(animated: true)
        }else{
            Alert.instance.showAlert(msg: "Unable to Add Contact. Please try again later.", title: "", sender: self)
        }
    }
    
    func updatedContact(isSuccess: Bool){
        if isSuccess{
            LoaderClass.sharedInstance.showActivityIndicator()
            self.navigationController?.popViewController(animated: true)
        }else{
            Alert.instance.showAlert(msg: "Unable to Update Contact. Please try again later.", title: "", sender: self)
        }
    }

    @objc func buddyTapped(sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tblVw.cellForRow(at: indexPath) as! AddressbookTableViewCell
        
        if isToUpdate {
            if addressbook.isBuddy{
                addressbook.isBuddy = false
            }else{
                addressbook.isBuddy = true
            }
            cell.imgBuddy.image = addressbook.isBuddy ? UIImage.init(named: "selected"):UIImage.init(named: "unSelected")
        }else{
            if cell.btnBuddy.isSelected{
                cell.btnBuddy.isSelected = false
            }else{
                cell.btnBuddy.isSelected = true
            }
            cell.imgBuddy.image = cell.btnBuddy.isSelected ? UIImage.init(named: "selected"):UIImage.init(named: "unSelected")
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let kbrect: CGRect? = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let heightOffset: CGFloat = self.tblVw.frame.origin.y + self.tblVw.frame.size.height 
        
        if heightOffset > (kbrect?.origin.y ?? 00) {
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.3)
            self.tblVw.contentOffset = CGPoint(x: 0, y: heightOffset - (kbrect?.origin.y)! )
            UIView.commitAnimations()
        } else {
            
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        self.tblVw.contentOffset = CGPoint(x: 0, y: 0)
        UIView.commitAnimations()
    }

    
}


extension AddressbookViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressbookTableViewCell", for: indexPath) as! AddressbookTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.btnBuddy.addTarget(self, action: #selector(buddyTapped(sender:)), for: UIControl.Event.touchUpInside)

        cell.displayContentType(object: addressbook)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AddressbookTableViewCell.height()
    }
}


//MARK:- UITextFieldDelegate....
extension AddressbookViewController :UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
