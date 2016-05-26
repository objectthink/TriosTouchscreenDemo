//
//  MainViewController.swift
//  TriosTouchscreenDemo
//
//  Created by stephen eshelman on 5/25/16.
//  Copyright © 2016 tainstruments.com. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, IMercuryApp
{
    @IBOutlet var _startButton: UIButton!
    @IBOutlet var _stopButton: UIButton!
    @IBOutlet weak var _togglelidButton: UIButton!
    @IBOutlet weak var _resetButton: UIButton!
    @IBOutlet weak var _backButton: UIButton!
    @IBOutlet weak var _homeButton: UIButton!
    
    var _currentPage:IMercuryPage!
    var _previousPage:IMercuryPage!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        _startButton.setImage(UIImage.init(named:"start_pressed"), forState: .Highlighted)
        _stopButton.setImage(UIImage.init(named:"stop_pressed"), forState: .Highlighted)
        _togglelidButton.setImage(UIImage.init(named:"open_close_pressed"), forState: .Highlighted)
        _resetButton.setImage(UIImage.init(named:"reset_auto_pressed"), forState: .Highlighted)
        _backButton.setImage((UIImage.init(named:"back_pressed")), forState: .Highlighted)
        _homeButton.setImage(UIImage.init(named:"home_pressed"), forState: .Highlighted)
    }
    
    func next(page:IMercuryPage)
    {
        let nextPage = (page as! UIViewController)
        let currentPage = childViewControllers.last! as UIViewController
        
        _previousPage = (currentPage as! IMercuryPage)
        
        currentPage.willMoveToParentViewController(nil)
        addChildViewController(nextPage)
        nextPage.view.frame = currentPage.view.frame
        
        transitionFromViewController(
            currentPage,
            toViewController: nextPage,
            duration: 0.25,
            options: .TransitionCrossDissolve,
            animations:
            { () -> Void in
            // nothing needed here
            },
            completion:
            { (finished) -> Void in
                currentPage.removeFromParentViewController()
                nextPage.didMoveToParentViewController(self)
            })
    }
    
    @IBAction func backButtonClicked(sender: AnyObject)
    {
        back()
    }
    
    func back()
    {
        if _previousPage != nil
        {
            next(_previousPage)            
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "EmbedSegue")
        {
            var page = segue.destinationViewController as! IMercuryPage
            
            page.app = self
            
            _currentPage = page
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
