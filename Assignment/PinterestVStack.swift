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

extension View {
  /// Dùng modifier này để gắn height cho từng item
  func pinterestHeight(_ h: CGFloat) -> some View {
    layoutValue(key: PinterestHeightKey.self, value: h)
  }
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
//        guard let maxWidth = proposal.width else {
//            return .zero
//        }
//        let itemWidth = (maxWidth - spacing * Double(columns - 1)) / Double(columns)
//        
//        var xIndex: Int = 0
//        var columnsHeights: [Double] = Array(repeating: bounds?.minY ?? 0, count: columns)
//        
//        subviews.enumerated().forEach { index, view in
//            let isFullWidth = view[PinterestFullWidthKey.self]
//            
//            if isFullWidth {
//                let currentY = columnsHeights.max() ?? 0
//                let proposed = ProposedViewSize(width: maxWidth, height: nil)
//                let height = view.sizeThatFits(proposed).height
//                
//                if let bounds {
//                    view.place(at: .init(x: bounds.minX, y: currentY), anchor: .topLeading, proposal: proposed)
//                }
//                let newY = currentY + height + spacing
//                columnsHeights.indices.forEach { index in
//                    columnsHeights[index] = newY
//                }
//            } else {
//                let proposed = ProposedViewSize(width: itemWidth, height: view.sizeThatFits(.unspecified).height)
//                
//                if let bounds {
//                    let x = (itemWidth + spacing) * Double(xIndex) + bounds.minX
//                    view.place(at: .init(x: x, y: columnsHeights[xIndex]), anchor: .topLeading, proposal: proposed)
//                }
//                
//                let height = view.dimensions(in: proposed).height
//                columnsHeights[xIndex] += height + spacing
//                let minimum = columnsHeights.enumerated().min {
//                    $0.element < $1.element
//                }?.offset ?? 0
//                xIndex = minimum
//            }
//        }
//        
//        guard let maxHeight = columnsHeights.max() else {
//            return .zero
//        }
//        
//        return .init(width: maxWidth, height: maxHeight - spacing)
        
        guard let maxWidth = proposal.width else { return .zero }
        let itemWidth = (maxWidth - spacing * Double(columns - 1)) / Double(columns)
        
        var xIndex = 0
        // khởi tạo mảng chứa “y offset” cho mỗi cột
        var columnsHeights = Array(repeating: bounds?.minY ?? 0, count: columns)
        
        for view in subviews {
            let isFullWidth = view[PinterestFullWidthKey.self]
            // đọc giá trị height tùy chỉnh (nếu có)
            let customH = view[PinterestHeightKey.self].map(Double.init)
            
            if isFullWidth {
                // 1) full‑width: dùng maxWidth, height = customH hoặc đo bằng sizeThatFits
                let y = columnsHeights.max() ?? 0
                let proposed = ProposedViewSize(width: maxWidth, height: nil)
                let h = customH
                ?? view.sizeThatFits(proposed).height
                if let b = bounds {
                    view.place(at: .init(x: b.minX, y: y),
                               anchor: .topLeading,
                               proposal: proposed)
                }
                // cập nhật lại tất cả cột để tránh “gap”
                let newY = y + h + spacing
                columnsHeights.indices.forEach { index in
                    columnsHeights[index] = newY
                }
//                columnsHeights = columnsHeights.indices.map { _ in newY }
                
            } else {
                // 2) ô thường: dùng itemWidth, height = customH hoặc đo qua dimensions()
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
                // chọn cột thấp nhất cho item tiếp theo
                xIndex = columnsHeights.enumerated()
                    .min(by: { $0.element < $1.element })!.offset
            }
        }
        
        // chiều cao bằng cột cao nhất trừ lần spacing cuối
        let totalH = (columnsHeights.max() ?? 0) - spacing
        return .init(width: maxWidth, height: totalH)
    }
    
    static var layoutProperties: LayoutProperties {
        var layoutProperties = LayoutProperties()
        layoutProperties.stackOrientation = .vertical
        return layoutProperties
    }
}
