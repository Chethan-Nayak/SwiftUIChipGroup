//
// Created by Shaban Kamel on 13/01/2022.
// Copyright (c) 2022 sha. All rights reserved.
//

import Foundation
import SwiftUI

public class ChipItem: ChipItemProtocol {
    public var id: String = UUID().uuidString
    public var name: String
    public var isSelected: Bool = false
    public var backgroundColor: Color

    public init(
            name: String,
            isSelected: Bool = false,
            backgroundColor: Color = .clear) {
        self.name = name
        self.isSelected = isSelected
        self.backgroundColor = backgroundColor
    }
}
