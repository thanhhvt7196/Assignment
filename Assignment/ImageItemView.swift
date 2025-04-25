//
//  ImageItemView.swift
//  Assignment
//
//  Created by thanh tien on 23/4/25.
//

import SwiftUI

struct ImageItemView: View {
    private let coordinateSpaceName = "ImageSpace"
    @State private var selectedTag: TagModel?
    @State private var tagPosition = CGPoint.zero
    @State private var overlayFrame = CGRect.zero
    
    private let tagDotSize = 24.0
    
    let image: ImageModel
    let height: CGFloat
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                CachedImageView(url: URL(string: image.url), placeholder: nil)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
                    .cornerRadius(8)
                
                ForEach(image.tags) { tag in
                    if let x = Double(tag.x), let y = Double(tag.y) {
                        TagDot()
                            .frame(width: tagDotSize, height: tagDotSize)
                            .position(x: proxy.size.width * x,
                                      y: proxy.size.height * y)
                            .onTapGesture {
                                withAnimation(.smooth) {
                                    selectedTag = tag
                                }
                            }
                    }
                }
                
                if let selectedTag,
                   let x = Double(selectedTag.x),
                   let y = Double(selectedTag.y) {
                    
                    TagContentView(tag: selectedTag)
                        .background {
                            GeometryReader { tagProxy in
                                Color.clear
                                    .onAppear {
                                        overlayFrame = tagProxy.frame(in: .named(coordinateSpaceName))
                                        tagPosition = getTagPosition(
                                            proxy: proxy,
                                            x: x,
                                            y: y,
                                            containerFrame: proxy.frame(in: .named(coordinateSpaceName)),
                                            overlayFrame: tagProxy.frame(in: .named(coordinateSpaceName))
                                        )
                                    }
                                    .onChange(of: tagProxy.frame(in: .named(coordinateSpaceName))) { oldFrame, newFrame in
                                        if (oldFrame != newFrame) {
                                            overlayFrame = tagProxy.frame(in: .named(coordinateSpaceName))
                                            tagPosition = getTagPosition(
                                                proxy: proxy,
                                                x: x,
                                                y: y,
                                                containerFrame: proxy.frame(in: .named(coordinateSpaceName)),
                                                overlayFrame: tagProxy.frame(in: .named(coordinateSpaceName))
                                            )
                                        }
                                    }
                            }
                        }
                        .position(tagPosition)
                    
                    Path { path in
                        path.move(to: CGPoint(x: proxy.size.width * x, y: proxy.size.height * y))
                        path.addLine(to: CGPoint(x: tagPosition.x, y: y <= 0.5 ? overlayFrame.minY : overlayFrame.maxY))
                    }
                    .stroke(Color.white, lineWidth: 2)
                    .shadow(color: .gray, radius: 2, x: 0, y: 0)
                }
            }
            .onTapGesture {
                withAnimation(.smooth) {
                    selectedTag = nil
                }
            }
        }
        .frame(height: height)
        .coordinateSpace(name: coordinateSpaceName)
        
    }
    
    private func isOverlayOutside(containerFrame: CGRect, overlayFrame: CGRect) -> Bool {
        guard !overlayFrame.isEmpty else {
            return false
        }
        return !containerFrame.contains(overlayFrame)
    }
    
    private func getTagPosition(proxy: GeometryProxy, x: Double, y: Double, containerFrame: CGRect, overlayFrame: CGRect) -> CGPoint {
        let defaultPosition = defaultTagPosition(proxy: proxy, x: x, y: y)
        var newXPosition = defaultPosition.x
        var newYPosition = defaultPosition.y
        if isOverlayOutside(containerFrame: containerFrame, overlayFrame: overlayFrame) {
            if overlayFrame.minX <= containerFrame.minX {
                newXPosition += (containerFrame.minX - overlayFrame.minX) + 10
            } else if overlayFrame.maxX >= containerFrame.maxX {
                newXPosition -= (overlayFrame.maxX - containerFrame.maxX) + 10
            }
            
            if overlayFrame.minY <= containerFrame.minY {
                newYPosition += (containerFrame.minY - overlayFrame.minY) + 10
            } else if overlayFrame.maxY >= containerFrame.maxY {
                newYPosition -= (overlayFrame.maxY - containerFrame.maxY) + 10
            }
        }
        if y <= 0.5 {
            newYPosition += (tagDotSize + 8) * 2
        } else {
            newYPosition -= (tagDotSize + 8) * 2
        }
        return CGPoint(x: newXPosition, y: newYPosition)
    }
    
    private func defaultTagPosition(proxy: GeometryProxy, x: Double, y: Double) -> CGPoint {
        let xPosition = proxy.size.width * x
        let yPosition = proxy.size.height * y
        
        return CGPoint(x: xPosition, y: yPosition)
    }
}

struct AdItemView: View {
    let index: Int
    let url: String
    let height: CGFloat
    
    var body: some View {
        CachedImageView(url: URL(string: url), placeholder: nil)
            .frame(height: height)
            .clipped()
            .cornerRadius(8)
            .overlay(alignment: .topLeading) {
                Text("AD = \(index)")
                    .foregroundStyle(.black)
                    .padding()
                    .background(.white)
                    .shadow(radius: 4)
                    .cornerRadius(8, corners: [.topLeft, .bottomRight])
            }
    }
}
