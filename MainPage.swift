//
//  MainPage.swift
//  TriosTouchscreenDemo
//
//  Created by stephen eshelman on 5/24/16.
//  Copyright © 2016 tainstruments.com. All rights reserved.
//

import UIKit

class MainPage: UIViewController, IMercuryPage
{
    @IBOutlet var _infoButton: UIButton!
    @IBOutlet var _signalsButton: UIButton!
    @IBOutlet var _settingsButton: UIButton!
    
    @IBOutlet var _autosamplerButton: UIButton!
    @IBOutlet var _methodsButton: UIButton!
    @IBOutlet var _utilitiesButton: UIButton!
    
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
        _infoButton.setImage(UIImage.init(named: "info_pressed"), forState: .Highlighted)
        _signalsButton.setImage(UIImage.init(named:"signals_pressed"), forState: .Highlighted)
        _settingsButton.setImage(UIImage.init(named:"settings_pressed"), forState: .Highlighted)
        _autosamplerButton.setImage(UIImage.init(named:"autosamp_pressed"), forState: .Highlighted)
        _methodsButton.setImage(UIImage.init(named:"methods_pressed"), forState: .Highlighted)
        _utilitiesButton.setImage(UIImage.init(named:"utilities_pressed"), forState: .Highlighted)
    }
    
    @IBAction func autosamplerButtonClicked(sender: AnyObject)
    {
        let page = self.storyboard?.instantiateViewControllerWithIdentifier("AutosamplerPage")
        
        _app.next(page as! IMercuryPage)
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
