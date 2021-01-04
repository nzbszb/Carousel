//
//  Home.swift
//  Carousel (iOS)
//
//  Created by Admin on 29/12/20.
//

import SwiftUI

//width...
var width = UIScreen.main.bounds.width

struct Home: View {
//    let frameHeight: CGFloat = 400
    @EnvironmentObject var model: CarouselViewModel
    @Namespace var animation
    var body: some View {
        
        ZStack {
            VStack {
                if !model.showContent{
                HStack{
                    Button(action: ResetViews, label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.gray)
                    })
                    Text("Health Tips")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.leading)
                    Spacer()
                }
                .padding()
                }
                
                //Carousel...
                ZStack{
                    ForEach(model.cards.indices.reversed(),id:\.self){index in
                        
                        HStack {
                            CardView(card: model.cards[index], animation: animation)
                                .frame(width: getCardWidth(index: index), height: getCardHeight(index: index))
                                .offset(x: getCardOffset(index: index))
                                .rotationEffect(.init(degrees: getCardRotation(index: index)))
                            Spacer(minLength: 0)
                        }
                        .frame(height: 400)
                        .contentShape(Rectangle())
                        .offset(x: model.cards[index].offset)
                        .gesture(DragGesture(minimumDistance: 0)
                                    .onChanged({ (value) in onChanged(value: value, index: index)
                                        
                                    }).onEnded({ (value) in
                                        onEnded(value: value, index: index)
                                        
                                    }))
                    }
                }
                .padding(.top,25)
                .padding(.horizontal,30)
                
                Button(action: ResetViews, label: {
                    
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                })
                .padding(.top, 35)
                
                Spacer()
            }
            
            //Detail View...
            
            if model.showCard{
                DetailView(animation: animation)
            }
        }
    }
    
    //Reseting Views...
    
    func ResetViews(){
        for index in model.cards.indices{
            
            withAnimation(.spring()){
                
                model.cards[index].offset = 0
                model.swipedCard = 0
            }
            
        }
    }
    
    func onChanged(value: DragGesture.Value, index: Int)
    {
        //only left swipe because value is < 0...
        
        if value.translation.width < 0{
            model.cards[index].offset = value.translation.width
        }
    }
    
    func onEnded(value: DragGesture.Value, index: Int)
    {
        withAnimation{
            if -value.translation.width > width / 3{
                model.cards[index].offset = -width
                model.swipedCard += 1
            }else{
                model.cards[index].offset = 0
            }
        }
    }
    
    //Getting Rotation When Card is Being Swiped...
    
    func getCardRotation(index: Int)->Double{
        
        let boxWidth = Double(width / 3)
        
        let offset = Double(model.cards[index].offset)
        
        let angle : Double = 5
        
        return (offset / boxWidth) * angle
    }
    
    //Getting Width And Height For Card
    
    func getCardHeight(index: Int) -> CGFloat {
        
        let height : CGFloat = 400
        //Again First Three Cards...
        let cardHeight = index - model.swipedCard <= 2 ? CGFloat(index - model.swipedCard) * 35 : 70
        return height - cardHeight
    }
    
    func getCardWidth(index: Int) -> CGFloat {
        let boxWidth = UIScreen.main.bounds.width - 120
        
        //For First Three Cards...deprecated because offset will take care of it
//        let cardWidth = index <= 2 ? CGFloat(index) * 30 : 60
        
        return boxWidth
    }
    
    //Getting Offset...
    
    func getCardOffset(index: Int) -> CGFloat {
        
        return index - model.swipedCard <= 2 ? CGFloat(index - model.swipedCard) * 30 : 60
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 12 mini")
    }
}
