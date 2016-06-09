//
//  SignalsTabbedPageHelp.swift
//  TriosTouchscreenDemo
//
//  Created by Admin on 6/8/16.
//  Copyright © 2016 tainstruments.com. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SignalsTabbedPageHelp: AVPlayerViewController, IMercuryPage
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
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        // Do any additional setup after loading the view.
        let url = NSURL(string:"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")
        //player?.replaceCurrentItemWithPlayerItem(AVPlayerItem(URL: url!))
        //player!.play()
        
        
        player = AVPlayer(URL: url!)
        player?.play()

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
