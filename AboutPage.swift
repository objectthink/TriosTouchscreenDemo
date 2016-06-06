//
//  AboutPage.swift
//  TriosTouchscreenDemo
//
//  Created by stephen eshelman on 6/6/16.
//  Copyright © 2016 tainstruments.com. All rights reserved.
//

import UIKit

class AboutPage: UIViewController, IMercuryPage
{

   @IBOutlet var _segmentedControl: UISegmentedControl!

   var _versionsController:UIViewController!
   var _optionsController:UIViewController!
   var _versionsPage:IMercuryPage!
   var _optionsPage:IMercuryPage!
   
   var _app:IMercuryApp!
   var app:IMercuryApp
      {
      get
      {
         return _app;
      }
      set
      {
         _app = newValue
      }
   }

   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      // Do any additional setup after loading the view.
      // Do any additional setup after loading the view.
      let attr = NSDictionary(object: UIFont(name: "HelveticaNeue-Bold", size: 18.0)!, forKey: NSFontAttributeName)
      UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , forState: .Normal)
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
   {
      if (segue.identifier == "EmbedSegue")
      {
         var page = segue.destinationViewController as! IMercuryPage
         
         page.app = self.app
         
         _versionsController = self.storyboard?.instantiateViewControllerWithIdentifier("VersionsPage")
         _versionsPage = _versionsController as! IMercuryPage
         
         _optionsController = self.storyboard?.instantiateViewControllerWithIdentifier("OptionsPage")
         _optionsPage = _optionsController as! IMercuryPage
         
      }
   }
   
   @IBAction func _segmentedControlValueChanged(sender: AnyObject)
   {
      var nextController:UIViewController
      var currentController:UIViewController
      var nextPage:IMercuryPage
      var currentPage:IMercuryPage
      
      switch _segmentedControl.selectedSegmentIndex
      {
      case 0:
         nextController = _versionsController
         currentController = childViewControllers.last! as UIViewController
         break
      case 1:
         nextController = _optionsController
         currentController = childViewControllers.last! as UIViewController
         break
      default:
         return
         break
      }
      
      nextPage = nextController as! IMercuryPage
      currentPage = currentController as! IMercuryPage
      
      currentController.willMoveToParentViewController(nil)
      
      //set before we add the sybview as prepareforsegue will be
      //triggered for pages with a container view
      nextPage.app = self.app
      
      addChildViewController(nextController)
      
      nextController.view.frame = currentController.view.frame
      
      transitionFromViewController(
         currentController,
         toViewController: nextController,
         duration: 0.25,
         options: .TransitionCrossDissolve,
         animations:
         { () -> Void in
            // nothing needed here
         },
         completion:
         { (finished) -> Void in
            currentController.removeFromParentViewController()
            nextController.didMoveToParentViewController(self)
      })
   }
   
   override func didReceiveMemoryWarning()
   {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
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
