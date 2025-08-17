//
//  View+.swift
//  BlockBuster
//
//  Created by Bill on 17/8/25.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
     func `if`<Content: View>(
         _ condition: @autoclosure () -> Bool,
         transform: (Self) -> Content
     ) -> some View {
         if condition() {
             transform(self)
         } else {
             self
         }
     }
}
