//
//  AddressDirectoryViewController.swift
//  RibbonSample
//
//  Created by Rajesh Yadav on 10/04/19.
//  Copyright © 2019 RJ. All rights reserved.
//

import UIKit
import CPaaSSDK

class AddressDirectoryViewController: BaseViewController {
    
    @IBOutlet weak var segmentControl   : UISegmentedControl!
    @IBOutlet weak var containerView    : UIView!
    var cpaas: CPaaS!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarColorForViewController(viewController: self, type: 1, titleString: "ADDRESSBOOK")

        segmentControl.selectedSegmentIndex = 0
        updateView()
    }
    
    //----------------------------------------------------------------
    // MARK:-
    // MARK:- Variables
    //----------------------------------------------------------------
    
    private lazy var directoryViewController: DirectoryViewController = {
        let vc  = DirectoryViewController(nibName:"DirectoryViewController",bundle:nil)
        vc.cpaas = self.cpaas
        // Add View Controller as Child View Controller
        self.add(asChildViewController: vc)
        
        return vc
    }()
    
    private lazy var addressListViewController: AddressListViewController = {
        let vc  = AddressListViewController(nibName:"AddressListViewController",bundle:nil)
        vc.cpaas = self.cpaas
        // Add View Controller as Child View Controller
        self.add(asChildViewController: vc)
        
        return vc
    }()
    
    
    //----------------------------------------------------------------
    // MARK:-
    // MARK:- Action Methods
    //----------------------------------------------------------------
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        updateView()
    }
    
    
    //----------------------------------------------------------------
    // MARK:-
    // MARK:- Custom Methods
    //----------------------------------------------------------------
    
    private func add(asChildViewController viewController: UIViewController) {
        
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    //----------------------------------------------------------------
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    //----------------------------------------------------------------
    
    private func updateView() {
        if segmentControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: addressListViewController)
            add(asChildViewController: directoryViewController)
        } else {
            remove(asChildViewController: directoryViewController)
            add(asChildViewController: addressListViewController)
        }
    }
    
    //----------------------------------------------------------------
    
    func setupView() {
        updateView()
    }
    
}
