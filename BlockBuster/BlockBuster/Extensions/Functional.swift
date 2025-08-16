//
//  Functional.swift
//  BlockBuster
//
//  Created by Bill on 16/8/25.
//

import Foundation
import SwiftUI

// Prefix operator for read-only binding
prefix operator §
public prefix func §<T>(_ value: T) -> Binding<T> {
    Binding(get: { value }, set: { _ in })
}

// Infix operator for binding with custom setter
infix operator §> : AssignmentPrecedence
public func §><T>(_ value: T, _ set: @escaping (T) -> Void) -> Binding<T> {
    Binding(get: { value }, set: set)
}
