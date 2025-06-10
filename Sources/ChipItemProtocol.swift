//
//  ItemProtocol.swift
//  Example
//
//  Created by Shorouk Mohamed on 04/12/2021.
//  Copyright © 2021 sha. All rights reserved.
//

import Foundation
import SwiftUI

public protocol ChipItemProtocol: Identifiable where Self: AnyObject {
    var id: String { get set }
    var name: String { get set }
    var isSelected: Bool { get set }
    var backgroundColor: Color { get }
}
