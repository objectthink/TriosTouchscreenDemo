//
//  MainViewController.swift
//  TriosTouchscreenDemo
//
//  Created by stephen eshelman on 6/5/16.
//  Copyright © 2016 tainstruments.com. All rights reserved.
//

import UIKit

//
//  MainViewController.swift
//  TriosTouchscreenDemo
//
//  Created by stephen eshelman on 5/25/16.
//  Copyright © 2016 tainstruments.com. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, IMercuryApp, MercuryInstrumentDelegate
{
   @IBOutlet weak var _backButton: UIButton!
   @IBOutlet weak var _homeButton: UIButton!
   
   var _currentPage:IMercuryPage!
   var _instrument:MercuryInstrument!
   
   var _signalsResponse: MercuryRealTimeSignalsStatusResponse! = nil
   
   var _pages:Stack<IMercuryPage>
   
   var instrument:MercuryInstrument
      {
      get
      {
         return _instrument
      }
      set
      {
         _instrument = newValue
      }
   }
   
   var _supportedSignals:[uint] =
      [
         IdDeltaT0C.rawValue,
         IdDeltaT0CFilt.rawValue,
         IdDeltaT0CUnc.rawValue,
         IdDeltaTC.rawValue,
         IdFlangeC.rawValue,
         IdHeatFlow.rawValue,
         IdT0UncorrectedMV.rawValue,
         IdT0C.rawValue,
         IdT0UncorrectedC.rawValue,
         IdCommonTime.rawValue
   ]
   
   required init?(coder aDecoder: NSCoder)
   {
      _pages = Stack<IMercuryPage>()
      
      super.init(coder: aDecoder)
   }
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      // Do any additional setup after loading the view.
      _backButton.setImage((UIImage.init(named:"back_pressed")), forState: .Highlighted)
      _homeButton.setImage(UIImage.init(named:"home_pressed"), forState: .Highlighted)
      
      _instrument = MercuryInstrument()
      
      _instrument.addDelegate(self)
      
      _instrument.connectToHost("10.52.52.117", andPort: 8080)
      
      _instrument.loginWithUsername(
         "MERCURY_TOUCHSCREEN_IPAD",
         machineName: "MAC",
         ipAddress: "10.10.0.0",
         access: 1000)
   }
   
   func next(inout page:IMercuryPage)
   {
      //let nextPage = (page as! UIViewController)
      //let currentPageController = childViewControllers.last! as UIViewController
      
      //peek and call canClose
      //then push page and call aboutToOpen, aboutToShow, postShow
      
      //set before we add the sybview as prepareforsegue will be
      //triggered for pages with a container view
      page.app = self
      
      transitionFromPage(_pages.peek(), to: page)
      
      _pages.push(page)
   }
   
   @IBAction func backButtonClicked(sender: AnyObject)
   {
      back()
   }
   
   @IBAction func homeButtonClicked(sender: AnyObject)
   {
      home()
   }
   
   func home()
   {
      //peek and call aboutToClose, canClose
      //pop and call aboutToRemove
      //peek again and call aboutToShow, postShow
      
      if _pages.peek() is MainPage
      {
         return
      }
      
      var page:IMercuryPage = _pages.peek()
      let fromPage:IMercuryPage = page;
      
      while(!(page is MainPage))
      {
         _pages.pop()
         page = _pages.peek()
      }
      
      transitionFromPage(fromPage, to: page)
   }
   
   func back()
   {
      //peek and call aboutToClose, canClose
      //pop and call aboutToRemove
      //peek again and call aboutToShow, postShow
      
      if _pages.peek() is MainPage
      {
         return
      }
      
      transitionFromPage(_pages.pop(), to: _pages.peek())
   }
   
   func transitionFromPage(
      from:IMercuryPage,
      to:IMercuryPage
      )
   {
      let fromController:UIViewController = from as! UIViewController
      let toController:UIViewController = to as! UIViewController
      
      fromController.willMoveToParentViewController(nil)
      
      addChildViewController(toController)
      
      toController.view.frame = fromController.view.frame
      
      transitionFromViewController(
         fromController,
         toViewController: toController,
         duration: 0.25,
         options: .TransitionCrossDissolve,
         animations:
         { () -> Void in
            // nothing needed here
         },
         completion:
         { (finished) -> Void in
            fromController.removeFromParentViewController()
            toController.didMoveToParentViewController(self)
      })
   }
   
   override func didReceiveMemoryWarning()
   {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
   {
      if (segue.identifier == "EmbedSegue")
      {
         var page = segue.destinationViewController as! IMercuryPage
         
         page.app = self
         
         _pages.push(page)
      }
   }
   
   func stat(message: NSData!, withSubcommand subcommand: uint)
   {
      if(subcommand == RealTimeSignalStatus.rawValue)
      {
         //print("REALTIMESIGNALS !!!!!!")
         
         _signalsResponse = MercuryRealTimeSignalsStatusResponse(message: message)
         
         dispatch_async(dispatch_get_main_queue(),
                        { () -> Void in
                           
                           let f:Float = self._signalsResponse.signals![Int(76)].floatValue
                           
                           if f == -Float.infinity
                           {
                              //self._temperatureLabel.text = "--- ℃"
                           }
                           else
                           {
                              //self._temperatureLabel.text = String.init(format: "%.2f ℃", f)
                           }
         })
      }
      
      if subcommand == ProcedureStatus.rawValue
      {
         let response = MercuryProcedureStatus(message: message)
         print(response.endStatus)
         print(response.runStatus)
         print(response.currentSegmentId)
         
         let runStatus = response.runStatus.rawValue
         dispatch_async(dispatch_get_main_queue(),
                        { () -> Void in
//                           switch(runStatus)
//                           {
//                           case  0:
//                              self._statusLabel.text = "Idle"
//                           case 1:
//                              self._statusLabel.text = "PreTest"
//                           case 2:
//                              self._statusLabel.text = "Test"
//                           case 3:
//                              self._statusLabel.text = "PostTest"
//                           default:
//                              self._statusLabel.text = ""
//                           }
                           
         })
      }
   }
   
   func connected()
   {
      _instrument.sendCommand(MercuryGetProcedureStatusCommand())
      { (r) -> Void in
         
         //self._statusLabel.text = "Some status"
         
         let response = MercuryProcedureStatusResponse(message: NSData(data: r.bytes))
         
         let runStatus = response.runStatus.rawValue
         dispatch_async(dispatch_get_main_queue(),
                        { () -> Void in
//                           switch(runStatus)
//                           {
//                           case  0:
//                              self._statusLabel.text = "Idle"
//                           case 1:
//                              self._statusLabel.text = "PreTest"
//                           case 2:
//                              self._statusLabel.text = "Test"
//                           case 3:
//                              self._statusLabel.text = "PostTest"
//                           default:
//                              self._statusLabel.text = "Unknown"
//                           }
                           
         })
      }
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

struct Stack<Element>
{
   var items = [Element]()
   
   mutating func push(item: Element)
   {
      items.append(item)
   }
   
   mutating func pop() -> Element
   {
      return items.removeLast()
   }
   
   func peek() -> Element
   {
      return items.last!
   }
}

