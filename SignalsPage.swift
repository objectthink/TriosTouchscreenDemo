//
//  SignalsPagwe.swift
//  TriosTouchscreenDemo
//
//  Created by stephen eshelman on 5/27/16.
//  Copyright © 2016 tainstruments.com. All rights reserved.
//

import UIKit

class SignalsPage: UITableViewController, IMercuryPage, MercuryInstrumentDelegate
{
   var _signalsResponse: MercuryRealTimeSignalsStatusResponse! = nil

   var _supportedSignals:[uint] =
   [
      IdSetPointTemperature.rawValue,
      IdTemperature.rawValue,
      IdFlangeC.rawValue,
      IdRefJunctionC.rawValue,
      IdHeaterC.rawValue,
      IdBasePurgeFlowRate.rawValue
      
      //IdDeltaT0C.rawValue,
      //IdDeltaT0CFilt.rawValue,
      //IdDeltaT0CUnc.rawValue,
      //IdDeltaTC.rawValue,
      //IdFlangeC.rawValue,
      //IdHeatFlow.rawValue,
      //IdT0UncorrectedMV.rawValue,
      //IdT0C.rawValue,
      //IdT0UncorrectedC.rawValue,
      //IdCommonTime.rawValue
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

   override func viewDidDisappear(animated: Bool)
   {
      app.instrument.removeDelegate(self)
   }
   
   override func viewDidAppear(animated: Bool)
   {
      app.instrument.addDelegate(self)
   }
   
   override
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      if _signalsResponse != nil
      {
         return 6
      }
      else
      {
         return 0
      }
   }
   
   override
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = tableView.dequeueReusableCellWithIdentifier("SignalCell") as! SignalCell

      let f:Float = self._signalsResponse.signals![Int(_supportedSignals[indexPath.row])].floatValue
      
      if f == -Float.infinity
      {
         cell._valueLabel.text = "---"
      }
      else
      {
         cell._valueLabel.text = String.init(format: "%.2f", f)
      }
      
      cell._nameLabel.text  = app.instrument.signalToString(_supportedSignals[indexPath.row])
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
   
   func stat(message: NSData!, withSubcommand subcommand: uint)
   {
      if(subcommand == RealTimeSignalStatus.rawValue)
      {
         _signalsResponse = MercuryRealTimeSignalsStatusResponse(message: message)
         
         dispatch_async(dispatch_get_main_queue(),
         { () -> Void in
            self.tableView.reloadData()
         })
      }
   }
   
   func connected()
   {
   }
   
   func accept(access: MercuryAccess)
   {
   }
   
   func response(
      message: NSData!,
      withSequenceNumber sequenceNumber: uint,
                         subcommand: uint,
                         status: uint)
   {
   }
   
   func ackWithSequenceNumber(sequencenumber: uint)
   {
   }
   
   func nakWithSequenceNumber(sequencenumber: uint, andError errorcode: uint)
   {
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
