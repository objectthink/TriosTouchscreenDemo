//
//  SignalCell.swift
//  TriosTouchscreenDemo
//
//  Created by stephen eshelman on 5/28/16.
//  Copyright © 2016 tainstruments.com. All rights reserved.
//

import UIKit

class SignalCell: UITableViewCell
{
   @IBOutlet var _nameLabel: UILabel!
   @IBOutlet var _valueLabel: UILabel!
   @IBOutlet var _unitsLabel: UILabel!
   
   override func awakeFromNib()
   {
      super.awakeFromNib()
      // Initialization code
   }
   
   override func setSelected(selected: Bool, animated: Bool)
   {
      super.setSelected(selected, animated: animated)
      
      // Configure the view for the selected state
   }
   
}
