//
//  ChartPage.swift
//  TriosTouchscreenDemo
//
//  Created by stephen eshelman on 5/29/16.
//  Copyright © 2016 tainstruments.com. All rights reserved.
//

import UIKit

class ChartPage:
   UIViewController,
   IMercuryPage,
   MercuryInstrumentDelegate,
   BEMSimpleLineGraphDataSource,
   BEMSimpleLineGraphDelegate

{
   var _values:Array<Float>!

   @IBOutlet var _plot: BEMSimpleLineGraphView!
   
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

      _values = Array<Float>()
      
      _plot.enableYAxisLabel = true
      _plot.enableXAxisLabel = true
      
      _plot.enableTouchReport = true;
      _plot.enablePopUpReport = true;
      _plot.enableYAxisLabel = true;
      _plot.autoScaleYAxis = true;
      _plot.alwaysDisplayDots = false;
      _plot.enableReferenceXAxisLines = true;
      _plot.enableReferenceYAxisLines = true;
      _plot.enableReferenceAxisFrame = true;
      
      _plot.formatStringForValues = "%.4f";
      
      _plot.animationGraphStyle = .None
   }

   override func viewDidDisappear(animated: Bool)
   {
      //app.instrument.removeDelegate(self)
   }
   
   override func viewDidAppear(animated: Bool)
   {
      app.instrument.addDelegate(self)
   }
   
   func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int
   {
      return _values.count
   }
   
   func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat
   {
      if _values.count > 0
      {
         return CGFloat(_values![index])
      }
      else
      {
         return 0.0
      }
   }
   
   func numberOfYAxisLabelsOnLineGraph(graph: BEMSimpleLineGraphView) -> Int
   {
      return 5
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
         
         dispatch_async(dispatch_get_main_queue(),
         { () -> Void in
            let signalsResponse = MercuryRealTimeSignalsStatusResponse(message: message)

            let f:Float = signalsResponse.signals![Int(76)].floatValue
            
            if f == -Float.infinity
            {
            }
            else
            {
            }

            self._values.append(f)
            
            if self._values.count > 100
            {
               self._values.removeAtIndex(0)
            }
            
            self._plot.reloadGraph()
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
