//
//  DirectoryViewController.swift
//  RibbonSample
//
//  Created by Rajesh Yadav on 05/04/19.
//  Copyright © 2019 RJ. All rights reserved.
//

import UIKit
import CPaaSSDK

class DirectoryViewController: UIViewController, DirectoryModuleDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblVw_Directory: UITableView!
    @IBOutlet weak var btn_Name: UIButton!
    @IBOutlet weak var btn_FirstName: UIButton!
    @IBOutlet weak var btn_LastName: UIButton!
    @IBOutlet weak var btn_PhoneNum: UIButton!

    @IBOutlet weak var viewDirectory: UIView!

    var cpaas: CPaaS!

    var filtered:[DirectoryBO] = []

    var directory_Handler = DirectoryModule()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVw_Directory.register(UINib(nibName: "DirectoryTableViewCell", bundle: nil), forCellReuseIdentifier: "DirectoryTableViewCell")
//        self.tblVw_Directory.isHidden = true
        
        self.btnFilterTapped(sender: btn_Name)
        self.searchBar.placeholder = NSLocalizedString("Search text", comment: "")
        
        directory_Handler.cpaas = self.cpaas
        directory_Handler.delegate_Directory = self
    }
    
    @IBAction func btnFilterTapped(sender: UIButton){
        let tag = sender.tag
        btn_Name.isSelected = false
        btn_FirstName.isSelected = false
        btn_LastName.isSelected = false
        btn_PhoneNum.isSelected = false
        if tag == 100 {
            btn_Name.isSelected = true
        }else if tag == 101 {
            btn_FirstName.isSelected = true
        }else if tag == 102 {
            btn_LastName.isSelected = true
        }else{
            btn_PhoneNum.isSelected = true
        }
    }
    
    func searchContactInDirectory(array: [DirectoryBO]) {
        filtered = array
        self.tblVw_Directory.reloadData()
        LoaderClass.sharedInstance.hideOverlayView()
    }
}


extension DirectoryViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DirectoryTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension DirectoryViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblVw_Directory.dequeueReusableCell(withIdentifier: "DirectoryTableViewCell") as! DirectoryTableViewCell
        
        let directoryBO = filtered[indexPath.row]
        cell.displayContentType(object: directoryBO)
        
        return cell
    }
}

extension DirectoryViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        for subView in searchBar.subviews {
            if subView.isKind(of: UIButton.self) {
                let cancelButton = subView as! UIButton
                cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
            }
        }
        self.tblVw_Directory.reloadData()
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        self.tblVw_Directory.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (range.location == 0 && range.length == 0 && text==" ") {
            return false;
        }
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        for possibleButton in searchBar.subviews {
            if possibleButton .isKind(of:UIButton.self) {
                let cancelButton = possibleButton as! UIButton
                cancelButton.isEnabled = true;
                break;
            }
        }
        
        LoaderClass.sharedInstance.showActivityIndicator()

        if btn_Name.isSelected{
            directory_Handler.searchContactInDirectory(searchText: searchBar.text ?? "", selectedFilterKeyType:.name ,selectedOrderType: .ascending, selectedSortType:.name)
        }else if btn_FirstName.isSelected{
            directory_Handler.searchContactInDirectory(searchText: searchBar.text ?? "", selectedFilterKeyType:.firstname ,selectedOrderType: .ascending, selectedSortType:.name)
        }else if btn_LastName.isSelected{
            directory_Handler.searchContactInDirectory(searchText: searchBar.text ?? "", selectedFilterKeyType:.lastname ,selectedOrderType: .ascending, selectedSortType:.name)
        }else if btn_PhoneNum.isSelected{
            directory_Handler.searchContactInDirectory(searchText: searchBar.text ?? "", selectedFilterKeyType:.phoneNumber ,selectedOrderType: .ascending, selectedSortType:.name)
        }else{
            directory_Handler.searchContactInDirectory(searchText: searchBar.text ?? "", selectedFilterKeyType:.name ,selectedOrderType: .ascending, selectedSortType:.name)
        }
        
    }
}
