//
//  NetworkPage.swift
//  TriosTouchscreenDemo
//
//  Created by stephen eshelman on 6/6/16.
//  Copyright © 2016 tainstruments.com. All rights reserved.
//

import UIKit

class GetSerialNumber:MercuryGet
{
   override init()
   {
      super.init()
      self.subCommandId = 0x00000002
   }
}

class GetName:MercuryGet
{
   override init()
   {
      super.init()
      self.subCommandId = 0x00000003
   }
}

class GetLocation:MercuryGet
{
   override init()
   {
      super.init()
      self.subCommandId = 0x00000004
   }
}

class NetworkPage: UIViewController, IMercuryPage
{
   @IBOutlet var _serialNumber: UILabel!
   @IBOutlet var _nameText: UITextField!
   @IBOutlet var _locationText: UITextField!
   
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
      app.instrument.sendCommand(GetSerialNumber())
      {(response)-> Void in
         
         if let str = NSString(data: response.bytes, encoding: NSUTF8StringEncoding) as? String
         {
            dispatch_async(dispatch_get_main_queue(),
            { () -> Void in
               self._serialNumber.text = str
            })
         }
         else
         {
            print("not a valid UTF-8 sequence")
         }
      }
      
      app.instrument.sendCommand(GetName())
      { (response) -> Void in
         if let str = NSString(data: response.bytes, encoding: NSUTF8StringEncoding) as? String
         {
            dispatch_async(dispatch_get_main_queue(),
            { () -> Void in
               self._nameText.text = self.mercuryStringFixup(str)
            })
         }
         else
         {
            print("not a valid UTF-8 sequence")
         }
      }
      
      app.instrument.sendCommand(GetLocation())
      { (response) -> Void in
         if let str = NSString(data: response.bytes, encoding: NSASCIIStringEncoding) as? String
         {
            dispatch_async(dispatch_get_main_queue(),
            { () -> Void in
               self._locationText.text = self.mercuryStringFixup(str)
            })
         }
         else
         {
            print("not a valid UTF-8 sequence")
         }
      }
   }
   
   override func didReceiveMemoryWarning()
   {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   func mercuryStringFixup(s:String)->String
   {
      var sOut:String = String()
      
      for character in s.characters
      {
         if character != "\0"
         {
            sOut.append(character)
         }
      }
      
      return sOut
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
