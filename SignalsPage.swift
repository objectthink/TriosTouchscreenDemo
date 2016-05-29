//
//  SignalsPagwe.swift
//  TriosTouchscreenDemo
//
//  Created by stephen eshelman on 5/27/16.
//  Copyright © 2016 tainstruments.com. All rights reserved.
//

import UIKit

class SignalsPage: UITableViewController, IMercuryPage
{
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
   
   override
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      return 7
   }
   
   override
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = tableView.dequeueReusableCellWithIdentifier("SignalCell") as! SignalCell

      cell._nameLabel.text  = "Set Point Temperature"
      cell._valueLabel.text = "39.99"
      cell._unitsLabel.text = "℃"
      
      return cell
   }
   
   override
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
