//
//  Resizable.swift
//  Cards
//
//  Created by Geoff Burns on 21/7/18.
//  Copyright © 2018 Geoff Burns. All rights reserved.
//

import Foundation
import UIKit

public protocol Resizable : AnyObject
{
    var adHeight : CGFloat { get }
    func arrangeLayoutFor(_ size:CGSize, bannerHeight:CGFloat)
}
