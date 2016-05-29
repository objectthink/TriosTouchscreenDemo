//
//  SignalsTabbedPage.swift
//  TriosTouchscreenDemo
//
//  Created by stephen eshelman on 5/27/16.
//  Copyright © 2016 tainstruments.com. All rights reserved.
//

import UIKit

class SignalsTabbedPage: UIViewController, IMercuryPage
{
   @IBOutlet var _segmentedControl: UISegmentedControl!
   
   var _chartController:UIViewController!
   var _signalsController:UIViewController!
   var _chartPage:IMercuryPage!
   var _signalsPage:IMercuryPage!
   
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
   
   required init?(coder aDecoder: NSCoder)
   {
      super.init(coder: aDecoder)
      
   }

   override func viewDidLoad()
   {
      super.viewDidLoad()
      
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
         
         _chartController = self.storyboard?.instantiateViewControllerWithIdentifier("ChartPage")
         _chartPage = _chartController as! IMercuryPage
         
         _signalsController = self.storyboard?.instantiateViewControllerWithIdentifier("SignalsPage")
         _signalsPage = _signalsController as! IMercuryPage

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
         nextController = _signalsController
         currentController = childViewControllers.last! as UIViewController
         break
      case 1:
         nextController = _chartController
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
}
