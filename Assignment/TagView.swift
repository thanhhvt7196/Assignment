//
//  TagView.swift
//  Assignment
//
//  Created by thanh tien on 25/4/25.
//

import SwiftUI

struct TagDot: View {
    var body: some View {
        Circle()
            .fill(Color.white)
            .stroke(Color.blue, style: .init(lineWidth: 2))
            .overlay {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
            }
    }
}

struct TagContentView: View {
    private let tag: TagModel
    
    init(tag: TagModel) {
        self.tag = tag
    }
    
    var body: some View {
        Text("\(tag.currency) \(String(format: "%g", tag.price))")
            .foregroundStyle(.black)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white)
                    .stroke(Color.gray, style: .init(lineWidth: 1))
            )
    }
}

#Preview {
    TagDot()
        .frame(width: 24, height: 24)
}
