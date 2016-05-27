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
      let attr = NSDictionary(object: UIFont(name: "HelveticaNeue-Bold", size: 18.0)!, forKey: NSFontAttributeName)
      UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , forState: .Normal)
   }
   
   override func didReceiveMemoryWarning()
   {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
}
