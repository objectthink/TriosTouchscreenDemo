//
//  SystemInfoPage.swift
//  TriosTouchscreenDemo
//
//  Created by Admin on 6/6/16.
//  Copyright © 2016 tainstruments.com. All rights reserved.
//

import UIKit

class SystemInfoPage: UIViewController, IMercuryPage
{
   @IBOutlet var _networkButton: UIButton!
   @IBOutlet var _aboutButton: UIButton!
   
   
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
      _networkButton.setImage(UIImage.init(named: "info_pressed"), forState: .Highlighted)
      _aboutButton.setImage(UIImage.init(named: "info_pressed"), forState: .Highlighted)
   }
   
   @IBAction func networkButtonClicked(sender: AnyObject)
   {
      let controller = self.storyboard?.instantiateViewControllerWithIdentifier("NetworkPage")
      var page = controller as! IMercuryPage
      
      _app.next(&page)// as! IMercuryPage)
   }
   
   @IBAction func aboutButtonClicked(sender: AnyObject)
   {
      let controller = self.storyboard?.instantiateViewControllerWithIdentifier("AboutPage")
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
