//
//  File.swift
//  
//
//  Created by クワシマ・ユウキ on 2022/09/28.
//

import Foundation

// Code from https://www.2nd-walker.com/2020/02/10/swift-extension-for-substring/
// Code License: https://www.2nd-walker.com/about/
extension String {
    // Index with using position of Int type
    func index(at position: Int) -> String.Index {
        return index((position.signum() >= 0 ? startIndex : endIndex), offsetBy: position)
    }
    // Subscript for using like a "string[i]"
    subscript (position: Int) -> String {
        let i = index(at: position)
        return String(self[i])
    }
    // Subscript for using like a "string[start..<end]"
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(at: bounds.lowerBound)
        let end = index(at: bounds.upperBound)
        return String(self[start..<end])
    }
    // Subscript for using like a "string[start...end]"
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(at: bounds.lowerBound)
        let end = index(at: bounds.upperBound)
        return String(self[start...end])
    }
    // Subscript for using like a "string[..<end]"
    subscript (bounds: PartialRangeUpTo<Int>) -> String {
        let i = index(at: bounds.upperBound)
        return String(prefix(upTo: i))
    }
    // Subscript for using like a "string[...end]"
    subscript (bounds: PartialRangeThrough<Int>) -> String {
        let i = index(at: bounds.upperBound)
        return String(prefix(through: i))
    }
    // Subscript for using like a "string[start...]"
    subscript (bounds: PartialRangeFrom<Int>) -> String {
        let i = index(at: bounds.lowerBound)
        return String(suffix(from: i))
    }
}
