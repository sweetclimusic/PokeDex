//
//  Inspection.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 20/01/2025.
//

/*
setup From: https://github.com/nalexn/ViewInspector/blob/0.9.7/guide.md#approach-2
 ViewInspection library for testing of SwiftUI Views, I use the Inspection method to determine when rendering is complete to begin testing.
*/

import Combine
import SwiftUI

internal final class Inspection<V> {

    let notice = PassthroughSubject<UInt, Never>()
    var callbacks = [UInt: (V) -> Void]()

    func visit(_ view: V, _ line: UInt) {
        if let callback = callbacks.removeValue(forKey: line) {
            callback(view)
        }
    }
}
