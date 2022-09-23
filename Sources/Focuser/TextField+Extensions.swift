//
//  File.swift
//  
//
//  Created by Augustinas Malinauskas on 01/09/2021.
//

import SwiftUI


public extension View {
    func focusedLegacy<T: Hashable>(_ focusedField: Binding<T?>, equals: T) -> some View {
        modifier(FocusModifier(focusedField: focusedField, equals: equals))
    }
    
    func focusedLegacy(_ condition: Binding<Bool>) -> some View {
        modifier(FocusModifierBool(isFocusedField: condition))
    }
}

@available(iOS 14.0, *)
public extension View {
    func focusEditor<T: FocusStateCompliant>(_ focusedField: Binding<T?>, equals: T) -> some View {
        modifier(FocusModifierTextEditor(focusedField: focusedField, equals: equals))
    }
}

