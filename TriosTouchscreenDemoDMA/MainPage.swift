//
//  MainPage.swift
//  TriosTouchscreenDemo
//
//  Created by Admin on 6/7/16.
//  Copyright © 2016 tainstruments.com. All rights reserved.
//

import UIKit

class MainPage: UIViewController, IMercuryPage
{
   @IBOutlet var _temperatureButton: UIButton!
   @IBOutlet var _positionButton:UIButton!
   @IBOutlet var _measureButton:UIButton!
   
   @IBOutlet var _preloadButton:UIButton!
   @IBOutlet var _floatButton:UIButton!
   @IBOutlet var _unlockedButton:UIButton!
   @IBOutlet var _lockedButton:UIButton!
   
   var _isSelected:Bool = false
   
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
      _temperatureButton.setImage((UIImage.init(named:"TempDn")), forState: .Highlighted)
      _positionButton.setImage((UIImage.init(named:"Position1Dn")), forState: .Highlighted)
      _measureButton.setImage((UIImage.init(named:"Measure1Dn")), forState: .Highlighted)
      
      //_preloadButton.setImage((UIImage.init(named:"PreloadDn")), forState: .Highlighted)
      //_floatButton.setImage((UIImage.init(named:"FloatDn")), forState: .Highlighted)
      //_unlockedButton.setImage((UIImage.init(named:"UnlockDn")), forState: .Highlighted)
      //_lockedButton.setImage((UIImage.init(named:"LockDn")), forState: .Highlighted)
   }
   
   override func didReceiveMemoryWarning()
   {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   @IBAction func modeRadioClicked(sender: AnyObject)
   {
      if _isSelected
      {
         _preloadButton.setImage((UIImage.init(named:"PreloadDn")), forState: .Normal)
         
      }
      else
      {
         _preloadButton.setImage((UIImage.init(named:"PreloadUp")), forState: .Normal)
         
      }
      
      _isSelected = !_isSelected
   }
   
   @IBAction func temperatureButtonClicked(sender: AnyObject)
   {
      let controller = self.storyboard?.instantiateViewControllerWithIdentifier("TemperaturePage")
      var page = controller as! IMercuryPage
      
      _app.next(&page)// as! IMercuryPage)
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
