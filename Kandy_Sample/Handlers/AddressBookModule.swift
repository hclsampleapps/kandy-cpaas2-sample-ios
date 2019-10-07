//
//  AddressBookModule.swift
//  Ribbon_SDK_Integration
//
//  Created by Rajesh Yadav on 15/03/19.
//  Copyright © 2019 Ribbon. All rights reserved.
//

import Foundation
import CPaaSSDK

protocol AddressBookDelegate {
    func fetchContactList(array: [AddressbookBO])
    func deleteSingleContact(isSuccess: Bool)
}

protocol AddressBookAddUpdateDelegate {
    func addedContact(isSuccess: Bool)
    func updatedContact(isSuccess: Bool)
}


class AddressBookModule: NSObject  {
    var cpaas: CPaaS!
    
    public static let sharedInstance = AddressBookModule()
    var service: CPAddressBookService?
    
    override init() {
        super.init()
    }

    
    var authentication: CPAuthenticationService {
        get {
            return self.cpaas.authenticationService
        }
    }
    
    var delegate_AddressBook:AddressBookDelegate?
    var delegate_AddUpdateAddressBook:AddressBookAddUpdateDelegate?

    
    func fetchContactList() {
        
        /// cpaas is the main instance which holds logged-in user.
        cpaas.addressBookService?.retrieveContactList(completion: { (error, contactList) in
            var arrAddressbook = [AddressbookBO]()

            if let error = error {
                NSLog("Couldn't retrieve contact list from addressbook - Error: \(error.localizedDescription)")
                self.delegate_AddressBook?.fetchContactList(array: arrAddressbook)
                return
            }
            
            
            for contact in contactList! {
                NSLog("Contact: \(contact)")
                NSLog("Name: \(contact.firstName) \(contact.lastName)")
                
                let addressbookBO = AddressbookBO()
                addressbookBO.contactId = contact.contactId
                addressbookBO.primaryContact = contact.contactId //'primaryContact' is inaccessible due to 'internal' protection level
                addressbookBO.firstName = contact.firstName
                addressbookBO.lastName = contact.lastName
                addressbookBO.email = contact.email
                addressbookBO.homePhoneNumber = contact.homePhoneNumber
                addressbookBO.businessPhoneNumber = contact.businessPhoneNumber
                addressbookBO.isBuddy = contact.buddy
                arrAddressbook.append(addressbookBO)
            }
            self.delegate_AddressBook?.fetchContactList(array: arrAddressbook)
        })
    }


    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }

    func createContact(model: AddressbookBO) -> Void {
        
        let id = randomString(length: 10)

        let entity = CPContact(contactId: id)
        entity.contactId = model.contactId
//        entity.username = model.primaryContact // primaryContact should be here
        entity.email = model.email
        entity.firstName = model.firstName
        entity.lastName = model.lastName
        entity.buddy = model.isBuddy
        entity.homePhoneNumber = model.homePhoneNumber
        entity.businessPhoneNumber = model.businessPhoneNumber
        
        /// Save contact to personal addressbook
        /// cpaas is the main instance which holds logged-in user.
        cpaas.addressBookService?.addContact(contact: entity, completion: { (error) in
                                                if let error = error {
                                                    NSLog("Couldn't save the contact to addressbook - Error: \(error.localizedDescription)")
                                                    self.delegate_AddUpdateAddressBook?.addedContact(isSuccess: false)
                                                    return
                                                }
                                                NSLog("Contact is saved to the addressbook")
                                                self.delegate_AddUpdateAddressBook?.addedContact(isSuccess: true)
        })
    }
    
    
    // In this method we need to update all fields.
    func updateContact(model: AddressbookBO) {
        
        let entity = CPContact(contactId: model.contactId ?? "")
        entity.contactId = model.contactId
//        entity.username = model.primaryContact // primaryContact should be here
        entity.email = model.email
        entity.firstName = model.firstName
        entity.lastName = model.lastName
        entity.buddy = model.isBuddy
        entity.homePhoneNumber = model.homePhoneNumber
        entity.businessPhoneNumber = model.businessPhoneNumber

        /// cpaas is the main instance which holds logged-in user.
        cpaas.addressBookService?.updateContact(contact: entity, completion: { (error) in
            if let error = error {
                self.delegate_AddUpdateAddressBook?.updatedContact(isSuccess: false)
                NSLog("Couldn't update the contact to addressbook - Error: \(error.localizedDescription)")
                return
            }
            self.delegate_AddUpdateAddressBook?.updatedContact(isSuccess: true)
            NSLog("Contact is updated")
        })
        
    }
    
    func deleteSingleContact(contact:CPContact) {
        
        /// Entity is the contact object that should be removed.
        /// cpaas is the main instance which holds logged-in user.
        cpaas.addressBookService?.deleteContact(identifier: contact.contactId,
                                                completion: { (error) in
                                                    if let error = error {
                                                        NSLog("Couldn't delete the contact from addressbook - Error: \(error.localizedDescription)")
                                                    self.delegate_AddressBook?.deleteSingleContact(isSuccess: false)
                                                        return
                                                    }
                                                    NSLog("Contact is deleted")
                                                    self.delegate_AddressBook?.deleteSingleContact(isSuccess: true)
        })
    }
    
    
    
    func getSingleContact(contactId:String) {
        /// cpaas is the main instance which holds logged-in user.
        cpaas.addressBookService?.getContact(contactId: contactId,
                                             completion: { (error, retrievedContact) in
                                                if let error = error {
                                                    NSLog("Couldn't get the contact from addressbook - Error: \(error.localizedDescription)")
                                                    return
                                                }
                                                
                                                NSLog("Contact is retrieved successfuly - Contact: \(retrievedContact)")
                                                NSLog("Name: \(retrievedContact.firstName) \(retrievedContact.lastName)")
                                                
        })
    }
    

}




/*
 func setToken() {
 self.authentication.connect(idToken: "self.idToken", accessToken: "self.accessToken", lifetime: "self.lifeTime") { (error, channelInfo) in
 if let error = error {
 print(error.localizedDescription)
 } else {
 self.channelInfo = channelInfo!
 print("Channel Info " + self.channelInfo)
 
 
 self.fetchContactList()
 //self.createContact()
 
 self.updateContact(listId: "abhishekk@globaleuro.net")
 
 let entity = CPContact(contactId: "iSUkkMtZ3N")
 /// Set relevant informations
 entity.mobile = "+12010000002"
 entity.email = "rahul@virtual-email.com"
 entity.firstName = "Rahul"
 entity.lastName = "Gupta"
 entity.buddy = true
 entity.homePhoneNumber = "+12010000003"
 entity.businessPhoneNumber = "+12010000004"
 
 //self.deleteSingleContact(contact:entity)
 //self.getSingleContact(contactId:"iSUkkMtZ3N")
 
 //self.getAddressbookLists()
 
 //                self.searchContactInDirectory(searchText: "k", selectedFilterKeyType:.lastname ,selectedOrderType: .ascending, selectedSortType:.name)
 }
 }
 }
 */
