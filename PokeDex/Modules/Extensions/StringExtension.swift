//
//  StringExtension.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 20/01/2025.
//

import Foundation

extension String {
    /// Extract the initial substring up to the index.
    /// parameter index: The index of the character to cut the string off at
     
    ///returns: The string after to the specified index until the end.
    public func idFromUrl(_ startRange: String) -> Int? {
        guard self.contains(startRange), let range = self.range(of: startRange)
        else {
            return nil
        }
        //mutating the string instance, find the distance within the string calling idFromUrl
        _ = self.distance(from: range.upperBound, to: self.endIndex)
        
        var result = self
        result.removeSubrange(range)
        guard let extractedId = try? Int(result, format: .number) else { return nil }
        return extractedId
    }
}
