//
//  Extensions.swift
//  Assignment
//
//  Created by thanh tien on 25/4/25.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = []

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

extension Array {
    func canInsert(at index: Int) -> Bool {
        return index >= 0 && index <= count
    }
}

extension Int {
    func getAllSmallerFibonacciNumbers() -> [Int] {
        guard self >= 1 else { return [] }
        var result: [Int] = []
        var a = 0
        var b = 1
        
        while b <= self {
            if b != 0, result.last != b {
                result.append(b)
            }
            (a, b) = (b, a + b)
        }
        
        return result
    }
}
