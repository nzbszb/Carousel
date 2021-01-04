//
//  Card.swift
//  Carousel (iOS)
//
//  Created by Admin on 29/12/20.
//

import SwiftUI

//Card Model...

struct Card : Identifiable {
    var id = UUID().uuidString
    var cardColor: Color
    var offset: CGFloat = 0
    var title: String
}
