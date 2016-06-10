//
//  IMercuryPage.swift
//  TriosTouchscreenDemo
//
//  Created by stephen eshelman on 5/25/16.
//  Copyright © 2016 tainstruments.com. All rights reserved.
//

import Foundation
import UIKit

protocol IMercuryApp
{
   var instrument:MercuryInstrument {get set}
   
   func next(inout page:IMercuryPage)
   func back()
}

protocol IMercuryPage
{
   var app:IMercuryApp {get set}
}
