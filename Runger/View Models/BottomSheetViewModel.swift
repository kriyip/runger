//
//  BottomSheetViewModel.swift
//  Runger
//
//  Created by Kristine Yip on 4/21/24.
//

import Foundation
import UIKit
import BottomSheet

//class BottomSheetViewModel: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Create a content view controller to display in the bottom sheet
//        let contentViewController = UIViewController()
//        contentViewController.view.backgroundColor = .white
//        
//        let label = UILabel()
//        label.text = "Hello, Bottom Sheet!"
//        label.textAlignment = .center
//        contentViewController.view.addSubview(label)
//        label.frame = CGRect(x: 0, y: 100, width: 300, height: 50)
//
//        // Create the BottomSheetViewController
////        let bottomSheetViewModel = BottomSheetViewModel(contentViewController: contentViewController)
//        
//        // Optional: Configure properties
//        bottomSheetViewModel.overlayColor = UIColor.black.withAlphaComponent(0.5) // Background dimming overlay
//        bottomSheetViewModel.overlayDismissalTapGestureEnabled = true // Allow user to tap on overlay to dismiss
//        bottomSheetViewModel.swipeToDismissEnabled = true // Allow swipe down to dismiss
//
//        // Present the BottomSheetViewController
//        present(bottomSheetViewModel, animated: true, completion: nil)
//    }
//}


class BottomSheetController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a view controller that will be shown in the bottom sheet
        let contentViewController = UIViewController()
        contentViewController.view.backgroundColor = .white  // Example background color

        // Initialize the bottom sheet controller with the content view controller
        let bottomSheetController = BottomSheetController()

        // Configure the bottom sheet (optional settings)
//        bottomSheetController.configuration.defaultHeight = .points(300)  // Set default height
//        bottomSheetController.configuration.snapPoints = [.minHeight, .fraction(0.5), .maxHeight]
//        bottomSheetController.configuration.isDismissable = true
        
//        bottomSheetController.set(defaultHeight: 300)

        // Add the bottom sheet as a child view controller
        addChild(bottomSheetController)
        view.addSubview(bottomSheetController.view)
        bottomSheetController.didMove(toParent: self)
    }
}
