//
//  ReadSize.swift
//  Xpiry date tracker
//
//  Created by Francesco on 31/03/25.
//


import SwiftUI

private struct sizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {
    func readSize(onChange: @escaping(CGSize) -> Void) -> some View {
        background(
            GeometryReader{
                geometryProxy in
                Color.clear.preference(key: sizePreferenceKey.self, value: geometryProxy.size)
                
            }
        ).onPreferenceChange(sizePreferenceKey.self,perform: onChange)
    }
}
