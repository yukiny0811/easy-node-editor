//
//  File.swift
//  
//
//  Created by クワシマ・ユウキ on 2022/09/17.
//

import Foundation

extension CGPoint: AdditiveArithmetic {
    public static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    public static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    func toCGSize() -> CGSize {
        return CGSize(width: self.x, height: self.y)
    }
}
