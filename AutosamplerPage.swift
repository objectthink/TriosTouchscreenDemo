//
//  AutosamplerPage.swift
//  TriosTouchscreenDemo
//
//  Created by stephen eshelman on 5/25/16.
//  Copyright © 2016 tainstruments.com. All rights reserved.
//

import UIKit

class AutosamplerPage: UIViewController, IMercuryPage
{
   @IBOutlet weak var _calibrationButton: UIButton!
   @IBOutlet weak var _loadunloadButton: UIButton!
   
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
      _calibrationButton.setImage(UIImage.init(named:"autosamp_pressed"), forState: .Highlighted)
      _loadunloadButton.setImage(UIImage.init(named:"loadunload_pressed"), forState: .Highlighted)
   }
   
   @IBAction func loadunloadButtonClicked(sender: AnyObject)
   {
      let controller = self.storyboard?.instantiateViewControllerWithIdentifier("AutosamplerLoadUnloadPage")
      var page = controller as! IMercuryPage
      
      _app.next(&page)// as! IMercuryPage)
   }
   
   @IBAction func calibrationButtonClicked(sender: AnyObject)
   {
      let controller = self.storyboard?.instantiateViewControllerWithIdentifier("AutosamplerCalibrationsPage")
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
