//
//  PageVC.swift
//  WeatherGift
//
//  Created by Christopher Donnelly on 3/10/19.
//  Copyright © 2019 Chris Donnelly. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {
    
    var currentPage = 0
    var locationsArray = ["Local City", "Sydney, Australia", "Accra, Ghana", "Uglich, Russia"]
    var pageControl: UIPageControl!
    var listButton: UIButton!
    var barButtonWidth: CGFloat = 44
    var barButtonHeight: CGFloat = 44
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self

        setViewControllers([createDetailVC(forPage: 0)], direction: .forward, animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configurePageControl()
        configureListButton()
    }
    
    func configurePageControl() {
        let pageControlHeight: CGFloat = barButtonHeight
        let pageControlWidth: CGFloat = view.frame.width - (barButtonWidth * 2)
        
        let safeHeight = view.frame.height - view.safeAreaInsets.bottom
        pageControl = UIPageControl(frame: CGRect(x: (view.frame.width - pageControlWidth) / 2, y: safeHeight - pageControlHeight, width: pageControlWidth, height: pageControlHeight))
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        pageControl.addTarget(self, action: #selector(pageControllerPressed), for: .touchUpInside)
        view.addSubview(pageControl)
    }
    
    @objc func segueToLocationsListVC() {
        print("Hey, you clicked me!")
    }
    
    func configureListButton() {
        
        let safeHeight = view.frame.height -
            view.safeAreaInsets.bottom
        
        listButton = UIButton(frame: CGRect(x: view.frame.width -
            barButtonWidth, y: safeHeight - barButtonHeight, width: barButtonWidth, height: barButtonHeight))
        
        listButton.setBackgroundImage(UIImage(named: "listButton"),
                                      for: .normal)
        listButton.setBackgroundImage(UIImage(named: "listbutton-highlighted"),
                                      for: .highlighted)
        listButton.addTarget(self, action:
            #selector(segueToLocationsListVC), for:
            .touchUpInside)
        view.addSubview(listButton)
    }
    
    func createDetailVC(forPage page: Int) -> DetailVC {
        
        currentPage = min(max(0, page), locationsArray.count - 1)
        
        let detailVC = storyboard!.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        detailVC.locationsArray = locationsArray
        detailVC.currentPage = currentPage
        
        return detailVC
    }


}

extension PageVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailVC {
            if currentViewController.currentPage < locationsArray.count - 1 {
                return createDetailVC(forPage: currentViewController.currentPage + 1)
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailVC {
            if currentViewController.currentPage > 0 {
                return createDetailVC(forPage: currentViewController.currentPage - 1)
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewConroller = pageViewController.viewControllers?[0] as? DetailVC {
            pageControl.currentPage = currentViewConroller.currentPage
        }
    }
    
    @objc func pageControllerPressed() {
        guard let currentViewController = self.viewControllers?[0] as? DetailVC else {return}
            currentPage = currentViewController.currentPage
            if pageControl.currentPage < currentPage {
                setViewControllers([createDetailVC(forPage: pageControl.currentPage)], direction: .reverse, animated: true, completion: nil)
            } else if pageControl.currentPage > currentPage {
                setViewControllers([createDetailVC(forPage: pageControl.currentPage)], direction: .forward, animated: true, completion: nil)
            }
        }
}
