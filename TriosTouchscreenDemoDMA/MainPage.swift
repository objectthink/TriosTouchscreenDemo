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