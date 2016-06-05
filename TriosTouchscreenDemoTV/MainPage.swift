//
//  MainPageTV.swift
//  TriosTouchscreenDemo
//
//  Created by stephen eshelman on 6/5/16.
//  Copyright © 2016 tainstruments.com. All rights reserved.
//

import UIKit

class MainPage: UIViewController, IMercuryPage
{
   @IBOutlet var _signalsButton: UIButton!
   
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
      _signalsButton.setImage(UIImage.init(named:"signals_pressed"), forState: .Highlighted)
   }
   
   @IBAction func signalsButtonClicked(sender: AnyObject)
   {
      let controller = self.storyboard?.instantiateViewControllerWithIdentifier("SignalsTabbedPage")
      var page = controller as! IMercuryPage
      
      _app.next(&page)// as! IMercuryPage)
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

