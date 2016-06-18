//
//  ServiceProvider.swift
//  TriosTopShelfExtension
//
//  Created by stephen eshelman on 6/18/16.
//  Copyright © 2016 tainstruments.com. All rights reserved.
//

import Foundation
import TVServices

class ServiceProvider: NSObject, TVTopShelfProvider
{
   override init()
   {
      super.init()
   }
   
   // MARK: - TVTopShelfProvider protocol
   
   var topShelfStyle: TVTopShelfContentStyle
   {
      // Return desired Top Shelf style.
      return .Sectioned
   }
   
   var topShelfItems: [TVContentItem]
   {
      //mercury instrument section
      let sectionIdentifier = TVContentIdentifier(identifier: "ID", container: nil)
      
      let section    = TVContentItem(contentIdentifier: sectionIdentifier!)
      section?.title = "Mercury"
      
      //item 1
      let itemIdentifier = TVContentIdentifier(identifier: "DIOID", container: nil)
      let item = TVContentItem(contentIdentifier: itemIdentifier!)
      
      item?.imageURL = NSBundle.mainBundle().URLForResource("DSC", withExtension: "jpeg")
      item?.title = "DIO"
      item?.displayURL = urlForIdentifier("dio")
      
      //item 1
      let itemIdentifier2 = TVContentIdentifier(identifier: "ATLASID", container: nil)
      let item2 = TVContentItem(contentIdentifier: itemIdentifier2!)
      
      item2?.imageURL = NSBundle.mainBundle().URLForResource("DSC", withExtension: "jpeg")
      item2?.title = "ATLAS"
      item2?.displayURL = urlForIdentifier("atlas")

      section?.topShelfItems = [item!, item2!]

      //other section
      let otherSectionIdentifier = TVContentIdentifier(identifier: "OTHER ID", container: nil)
      
      let otherSection    = TVContentItem(contentIdentifier: otherSectionIdentifier!)
      otherSection?.title = "Other"
      
      let otherItemIdentifier = TVContentIdentifier(identifier: "OTHER ITEM", container: nil)
      let otherItem = TVContentItem(contentIdentifier: otherItemIdentifier!)
      
      otherItem?.imageURL = NSBundle.mainBundle().URLForResource("discovery", withExtension: "jpeg")
      otherItem?.title = "OTHER"
      otherItem?.displayURL = urlForIdentifier("other")
      
      otherSection?.topShelfItems = [otherItem!]
      
      // Create an array of TVContentItems.
      return [section!, otherSection!]
   }
   
   private func urlForIdentifier(identifier:String)->NSURL
   {
      let components = NSURLComponents()
      
      components.scheme = "triostouchscreendemo"
      components.queryItems = [NSURLQueryItem(name:"identifier", value: identifier)]
      
      return components.URL!
   }
}

