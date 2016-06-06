//
//  AutosamplerCalibrationsPage.swift
//  TriosTouchscreenDemo
//
//  Created by stephen eshelman on 6/5/16.
//  Copyright © 2016 tainstruments.com. All rights reserved.
//

import UIKit

class AutosamplerCalibrationsPage: UIViewController, IMercuryPage
{
   var _calibrations:[String] =
   [
      "All",
      "Tray 1",
      "Sample",
      "Reference",
      "Lid Open",
      "Lid Closed (Park)",
      "Waste Bin",
      "Gripper Open Cell",
      "Gripper Open Tray",
      "Gripper Closed",
      "Gripper Release (Min)"
   ]
   
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
   }
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      return 7
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = tableView.dequeueReusableCellWithIdentifier("AutosamplerCalibrationCell")
      
      cell!.textLabel?.text = _calibrations[indexPath.row]
      cell!.textLabel?.font = UIFont(name:"Avenir", size:32)
      
      return cell!
   }
   
   func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
   {
      return 65
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
