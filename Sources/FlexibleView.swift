//
//  FlexibleView.swift
//  Example
//
//  Created by Shorouk Mohamed on 04/12/2021.
//  Copyright © 2021 sha. All rights reserved.
//

import SwiftUI

struct ItemContainer<T: Identifiable>: Hashable where T: AnyObject {
    let item: T

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(item))
    }

    static func ==(lhs: ItemContainer<T>, rhs: ItemContainer<T>) -> Bool {
        lhs.item.id == rhs.item.id
    }
}

public struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element, CGFloat) -> Content  // Add width param here
    
    @State var elementsSize: [Data.Element: CGSize] = [:]
    
    public init(
        availableWidth: CGFloat,
        data: Data,
        spacing: CGFloat,
        alignment: HorizontalAlignment,
        content: @escaping (Data.Element, CGFloat) -> Content  // Update init
    ) {
        self.availableWidth = availableWidth
        self.data = data
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: alignment, spacing: spacing) {
                ForEach(computeRows(), id: \.self) { rowElements in
                    let totalSpacing = spacing * CGFloat(max(rowElements.count - 1, 0))
                    let totalWidthUsed = rowElements.reduce(0) { partialResult, element in
                        partialResult + (elementsSize[element]?.width ?? 0)
                    }
                    // Calculate extra width per chip to fill availableWidth
                    let leftoverWidth = max(availableWidth - totalWidthUsed - totalSpacing, 0)
                    let extraWidthPerChip = leftoverWidth / CGFloat(rowElements.count)
                    
                    HStack(spacing: spacing) {
                        ForEach(rowElements, id: \.self) { element in
                            // Pass width as intrinsic width + extraWidthPerChip
                            let intrinsicWidth = elementsSize[element]?.width ?? 0
                            content(element, intrinsicWidth + extraWidthPerChip)
                                .fixedSize(horizontal: false, vertical: true)
                                .readSize { size in
                                    elementsSize[element] = size
                                }
                        }
                    }
                }
            }
        }
    }
    
    private func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth
        
        for element in data {
            let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]
            
            if remainingWidth - elementSize.width >= 0 {
                rows[currentRow].append(element)
                remainingWidth -= (elementSize.width + spacing)
            } else {
                // start a new row
                currentRow += 1
                rows.append([element])
                remainingWidth = availableWidth - elementSize.width - spacing
            }
        }
        
        return rows
    }
}


extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
                GeometryReader { geometryProxy in
                    Color.clear
                            .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
                }
        )
                .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}
