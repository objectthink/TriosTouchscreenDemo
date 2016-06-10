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
import Moscapsule
import Unbox

class MainViewController: UIViewController, IMercuryApp
{
   @IBOutlet weak var _homeButton: UIButton!
   @IBOutlet weak var _temperatureLabel: UILabel!
   @IBOutlet weak var _positionLabel: UILabel!

   var _currentPage:IMercuryPage!
   var _instrument:MercuryInstrument!
   var _pages:Stack<IMercuryPage>
   
   var mqttClient:MQTTClient!

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
   
   required init?(coder aDecoder: NSCoder)
   {
      _pages = Stack<IMercuryPage>()
      
      super.init(coder: aDecoder)
   }
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      _homeButton.setImage(UIImage.init(named:"home_pressed"), forState: .Highlighted)
      
      dispatch_async(dispatch_get_main_queue(),
      { () -> Void in
         // set MQTT Client Configuration
         let mqttConfig = MQTTConfig(
            clientId: "SNE",
            host: "ProgSci.net",          //"test.mosquitto.org",
            port: 1883,
            keepAlive: 60)
                        
         mqttConfig.onPublishCallback =
         { messageId in
            NSLog("published (mid=\(messageId))")
         }
                        
         mqttConfig.onMessageCallback =
         { mqttMessage in
            
            NSLog("MQTT Message received: payload=\(mqttMessage.payloadString)")
            
            do
            {
                let temperature:Temperature = try Unbox(mqttMessage.payload)

                print(temperature.current)
                print(temperature.setPoint)
                
                dispatch_async(dispatch_get_main_queue(),
                { () -> Void in
                    //self._temperatureLabel.text = "\(temperature.current)"
                    self._temperatureLabel.text = NSString(format: "%.2f ℃", temperature.current) as String
                    
                    if self._pages.peek() is ITemperature
                    {
                        (self._pages.peek() as! ITemperature).updateTemperature(temperature)
                    }
                });
            }
            catch
            {
            }
            
            do
            {
               let lcdStat:LCDStat = try Unbox(mqttMessage.payload)
               
               dispatch_async(dispatch_get_main_queue(),
                  { () -> Void in
                     if self._pages.peek() is ILCDStat
                     {
                        (self._pages.peek() as! ILCDStat).update(lcdStat)
                     }
               });
            }
            catch
            {
            }
         }
                        
         // create new MQTT Connection
         self.mqttClient = MQTT.newConnection(mqttConfig)
                        
         // publish and subscribe
         //self.mqttClient.publishString("message", topic: "publish/topic", qos: 2, retain: false)
         //self.mqttClient.subscribe("DMAMQ/DDMA-1B/#", qos: 2)
         
         self.mqttClient.subscribe("DMAMQ/DDMA-1B/LCDStat", qos: 2)
         self.mqttClient.subscribe("DMAMQ/DDMA-1B/LCDStat/Temp", qos: 2)

         // disconnect
         //mqttClient.disconnect()
                        
      })
      
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
   
   /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
   
}

struct Temperature: Unboxable
{
    let current: Double
    let setPoint: Double
    
    init(unboxer: Unboxer)
    {
        self.current = unboxer.unbox("Temperature")
        self.setPoint = unboxer.unbox("SetPoint")
    }
}

struct LCDStat: Unboxable
{
   let temperature:Double
   let position: Double
   
   init(unboxer: Unboxer)
   {
      self.temperature = unboxer.unbox("Temperature")
      self.position = unboxer.unbox("Position")
   }
}

protocol ITemperature
{
   func updateTemperature(temp:Temperature)
}

protocol ILCDStat
{
   func update(lcdStat:LCDStat)
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


