//
//  ViewController.swift
//  Doc2YourDoorHkCustomer
//
//  Created by Eddie Lau on 22/11/14.
//  Copyright (c) 2014 42 Labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var _pageViewController: UIPageViewController?
    let _pageTitles = ["Welcome Patient", "How?", "Find Doctor Now !"]
    let _pageImages = ["blur_01.png", "blur_02.png", "blur_03.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, t`ypically from a nib.
        
        // Create page view controller
        setupPageViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startWalkthrough(sender: UIButton) {
        var startingViewController = viewControllerAtIndex(0) as WalkthroughPageContentViewController
        var viewControllers = [startingViewController]
        _pageViewController!.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if (completed) {
            let pageContentViewController = pageViewController.viewControllers[0] as WalkthroughPageContentViewController
            let index = pageContentViewController.pageIndex
            let backgroundImageName = _pageImages[index] as NSString
            
            UIView.transitionWithView(self.backgroundImage, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve,
                animations: { () -> Void in
                    self.backgroundImage.image = UIImage(named: backgroundImageName)
                }, completion: { (Bool) -> Void in
                
                }
            )
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let pageContentViewController = viewController as WalkthroughPageContentViewController
        var index = pageContentViewController.pageIndex;
        
        if ((index == 0) || (index == NSNotFound)) {
            return nil;
        }
        
        index--;
        return self.viewControllerAtIndex(index);
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let pageContentViewController = viewController as WalkthroughPageContentViewController
        var index = pageContentViewController.pageIndex;
        
        if (index == NSNotFound) {
            return nil
        }
        
        index++;
        if (index == _pageTitles.count) {
            return nil
        }
        
        return viewControllerAtIndex(index);
    }
    
    func viewControllerAtIndex(index: NSInteger) -> UIViewController? {
        if ((_pageTitles.count == 0) || (index >= _pageTitles.count)) {
            return nil
        }
        
        var pageContentViewController = storyboard!.instantiateViewControllerWithIdentifier("WalkthroughPageContent") as WalkthroughPageContentViewController
        pageContentViewController.titleText = _pageTitles[index] as NSString
        pageContentViewController.pageIndex = index
        
        return pageContentViewController
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> NSInteger {
        return _pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> NSInteger {
        return 0
    }
    
    private func setupPageViewController() {
        _pageViewController = storyboard!.instantiateViewControllerWithIdentifier("WalkthroughPageView") as? UIPageViewController
        _pageViewController!.dataSource = self
        _pageViewController!.delegate = self
        
        var startingViewController = viewControllerAtIndex(0)
        var viewControllers = [startingViewController!]
        _pageViewController!.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        // Change the size of page view controller
        _pageViewController!.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50)

        addChildViewController(_pageViewController!)
        view.addSubview(_pageViewController!.view)
        _pageViewController!.didMoveToParentViewController(self)
    }
}

