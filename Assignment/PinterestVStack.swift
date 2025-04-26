//
//  PinterestVStack.swift
//  Assignment
//
//  Created by thanh tien on 22/4/25.
//

import SwiftUI

struct PinterestHeightKey: LayoutValueKey {
  static let defaultValue: CGFloat? = nil
}

struct PinterestFullWidthKey: LayoutValueKey {
    static let defaultValue = false
}

struct PinterestVStack: Layout {
    private let columns: Int
    private let spacing: Double
    
    init(columns: Int, spacing: Double) {
        self.columns = columns
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        return calculateSize(for: subviews, in: proposal)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        calculateSize(for: subviews, in: proposal, placeInBounds: bounds)
    }
    
    @discardableResult
    private func calculateSize(for subviews: Subviews, in proposal: ProposedViewSize, placeInBounds bounds: CGRect? = nil) -> CGSize {
        guard let maxWidth = proposal.width else { return .zero }
        let itemWidth = (maxWidth - spacing * Double(columns - 1)) / Double(columns)
        
        var xIndex = 0
        var columnsHeights = Array(repeating: bounds?.minY ?? 0, count: columns)
        
        for view in subviews {
            let isFullWidth = view[PinterestFullWidthKey.self]
            let customH = view[PinterestHeightKey.self].map(Double.init)
            
            if isFullWidth {
                let y = columnsHeights.max() ?? 0
                let proposed = ProposedViewSize(width: maxWidth, height: nil)
                let h = customH
                ?? view.sizeThatFits(proposed).height
                if let b = bounds {
                    view.place(at: .init(x: b.minX, y: y),
                               anchor: .topLeading,
                               proposal: proposed)
                }
                let newY = y + h + spacing
                columnsHeights.indices.forEach { index in
                    columnsHeights[index] = newY
                }
                
            } else {
                let y = columnsHeights[xIndex]
                let proposed = ProposedViewSize(width: itemWidth, height: nil)
                let h = customH
                ?? view.dimensions(in: proposed).height
                if let b = bounds {
                    let x = (itemWidth + spacing) * Double(xIndex) + b.minX
                    view.place(at: .init(x: x, y: y),
                               anchor: .topLeading,
                               proposal: proposed)
                }
                columnsHeights[xIndex] = y + h + spacing
                xIndex = columnsHeights.enumerated()
                    .min(by: { $0.element < $1.element })!.offset
            }
        }
        
        let totalH = (columnsHeights.max() ?? 0) - spacing
        return .init(width: maxWidth, height: totalH)
    }
    
    static var layoutProperties: LayoutProperties {
        var layoutProperties = LayoutProperties()
        layoutProperties.stackOrientation = .vertical
        return layoutProperties
    }
}
