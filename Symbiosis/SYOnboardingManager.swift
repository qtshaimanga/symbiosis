//
//  SYOnboardingManager.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 19/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import UIKit

class SYOnboardingManager: UIViewController {
    
    @IBOutlet weak var pageIndexControl: UIPageControl!
    @IBOutlet weak var pageContainer: UIView!

    
    var pageViewController: SYOnboarding? {
        didSet {
            pageViewController?.onboardingDelegate = self
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let pageViewController = segue.destinationViewController as? SYOnboarding {
            
            self.pageViewController = pageViewController
        }
    }
    
    
}

extension SYOnboardingManager: protocolPageViewControllerDelegate {
    
    func PageViewController(tutorialPageViewController: SYOnboarding,
                            didUpdatePageCount count: Int) {
        pageIndexControl.numberOfPages = count
    }
    
    func PageViewController(tutorialPageViewController: SYOnboarding,
                            didUpdatePageIndex index: Int) {
        pageIndexControl.currentPage = index
    }
    
}