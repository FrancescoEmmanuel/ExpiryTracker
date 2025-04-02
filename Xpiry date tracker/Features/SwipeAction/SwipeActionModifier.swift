//
//  SwipeActionModifier.swift
//  Xpiry date tracker
//
//  Created by Francesco on 31/03/25.
//

import SwiftUI

struct SwipeActionModifier: ViewModifier {
    
    @State private var size: CGSize = .init(width:1,height:1)
    func body(content: Content) -> some View {
        List{
            LazyVStack{
                content
                
            }
            .frame(minHeight:44)
            .readSize { size in
                self.size = size
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
           
            
        }
        .scrollDisabled(true)
        .listStyle(.plain)
        .frame(height: size.height)
//        .contentMargins(.vertical, EdgeInsets(), for: .scrollContent)
       
    }
}


extension View{
    func enableSwipeAction() -> some View{
        self.modifier(SwipeActionModifier())
    }
}
