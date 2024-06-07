//
//  SwipeSongView.swift
//  MCL
//
//  Created by Francesca Ferrini on 30/05/24.
//

import SwiftUI

struct SwipeSongView<Content: View, Right: View>: View {
    
    var content: () -> Content
    var right: () -> Right
    
    var itemHeight: CGFloat
    
    init(@ViewBuilder content: @escaping () -> Content,
         @ViewBuilder right: @escaping () -> Right,
         itemHeight: CGFloat){
        self.content = content
        self.right = right
        self.itemHeight = itemHeight
    }
    
    @State var hoffset: CGFloat = 0  //tiene traccia di quanto scorriamo in orizzontale
    @State var anchor: CGFloat = 0   //blocca la posizione di scorrimento in determinati punti
    
    let screenWidth = UIScreen.main.bounds.width
    var anchorWidth: CGFloat {screenWidth / 3}   //larghezza del contenuto sinistro o destro
    var swipeThreshold: CGFloat {screenWidth / 15} //soglia dello schermo (scorrimento più o meno sensibile)
    
    @State var rightPast = false
    
    
    var drag: some Gesture{
        DragGesture()
            .onChanged{ value in
                withAnimation{
                    hoffset = anchor + value.translation.width
                    
                    if abs(hoffset) > anchorWidth{
                        hoffset = -anchorWidth
                        
                    }
                    
                    if anchor > 0 {
                        rightPast = hoffset < -anchorWidth + swipeThreshold
                    }else{
                        rightPast = hoffset < -swipeThreshold
                    }
                }
            }
            .onEnded{ value in
                withAnimation {
                    if rightPast {
                        anchor = -anchorWidth  //l' ancoraggio rappresenta il punto di partenza dell'offset
                    } else{
                        anchor = 0
                    }
                    hoffset = anchor   //punto di partenza per ogni offset
                }
            }
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                HStack(spacing: 0) {
                    Spacer()  
                    
                    right()
                        .frame(width: anchorWidth, height: 50)
                        .zIndex(-1)
                        .clipped()
                }
                
                content()
                    .frame(width: geometry.size.width)
                    .gesture(drag)
                    .offset(x: hoffset)
            }
        }
       
        
    }
}

