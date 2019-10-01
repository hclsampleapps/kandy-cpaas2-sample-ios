//
//  DirectoryModule.swift
//  Ribbon_SDK_Integration
//
//  Created by Rajesh Yadav on 15/03/19.
//  Copyright © 2019 Ribbon. All rights reserved.
//

import Foundation
import CPaaSSDK

protocol DirectoryModuleDelegate {
    func searchContactInDirectory(array: [DirectoryBO])
}

class DirectoryModule: NSObject  {
    var cpaas: CPaaS!
    
    public static let sharedInstance = DirectoryModule()
    var service: CPAddressBookService?
    
    override init() {
        super.init()
    }
    
    
    var authentication: CPAuthenticationService {
        get {
            return self.cpaas.authenticationService
        }
    }
    
    var delegate_Directory:DirectoryModuleDelegate?
    
    
    
    
    
    func searchContactInDirectory(searchText: String, selectedFilterKeyType:CPAddressBook.FieldType,selectedOrderType: CPAddressBook.OrderType, selectedSortType:CPAddressBook.FieldType) -> Void {
        
        let type = selectedFilterKeyType //name, f-name
        let orderType = selectedOrderType // asscending
        let sortType = selectedSortType //name, f-name
        let max = 50
        
        
        let searchObj = CPSearch(filter: CPSearchFilter(value: searchText, forType: type))
        searchObj.orderBy = orderType
        searchObj.sortBy = sortType
        searchObj.limit = max
        cpaas.addressBookService?.search(with: searchObj, completion: { (error, searchResult) in
            
            var arrDirectory = [DirectoryBO]()
            if let error = error {
                NSLog("Couldn't search in directory - Error: \(error.localizedDescription)")
                self.delegate_Directory?.searchContactInDirectory(array: arrDirectory)
                return
            }
            
            //            self.searchResultObject = searchResult
            NSLog("Searched Contact is retrieved successfuly - Contact: \(searchResult)")
            NSLog("Searched Contact is retrieved successfuly - Contact: \(searchResult?.contacts)")
            
            for contact in (searchResult?.contacts!)! {
                NSLog("Contact: \(contact)")
                NSLog("Name: \(contact.firstName) \(contact.lastName)")
                
                let directoryBO = DirectoryBO()
                directoryBO.name = contact.contactId
                directoryBO.firstName = contact.firstName
                directoryBO.lastName = contact.lastName
                directoryBO.email = contact.email
                directoryBO.userId = contact.contactId
                directoryBO.photoUrl = contact.photoUrl
                directoryBO.isBuddy = contact.buddy
                arrDirectory.append(directoryBO)
            }
            
            self.delegate_Directory?.searchContactInDirectory(array: arrDirectory)
        })
    }
    
}
