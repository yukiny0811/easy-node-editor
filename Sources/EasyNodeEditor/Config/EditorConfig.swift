//
//  File.swift
//  
//
//  Created by クワシマ・ユウキ on 2022/09/27.
//

import SwiftUI

public struct EditorConfig {
    public static let defaultConfig = EditorConfig()
    public init(editorBackgroundColor: Color = Color(red: 0.12, green: 0.12, blue: 0.12),
                nodeBackgroundColor: Color = Color(red: 0.72, green: 0.72, blue: 0.72),
                moveFillColor: Color = Color(red: 0.95, green: 0.95, blue: 0.95),
                connectionColor: Color = Color(red: 1.0, green: 0.3, blue: 0.3),
                nodeSelectBackgroundColor: Color = Color(red: 0.3, green: 0.3, blue: 0.3),
                nodeSelectTextColor: Color = Color(red: 0.9, green: 0.9, blue: 0.9),
                nodeSelectViewWidth: CGFloat = 230,
                editorWidth: CGFloat = 1500,
                editorHeight: CGFloat = 1500
    ) {
        self.editorBackgroundColor = editorBackgroundColor
        self.nodeBackgroundColor = nodeBackgroundColor
        self.moveFillColor = moveFillColor
        self.connectionColor = connectionColor
        self.nodeSelectBackgroundColor = nodeSelectBackgroundColor
        self.nodeSelectTextColor = nodeSelectTextColor
        self.nodeSelectViewWidth = nodeSelectViewWidth
        self.editorWidth = editorWidth
        self.editorHeight = editorHeight
    }
    public var editorBackgroundColor: Color
    public var nodeBackgroundColor: Color
    public var moveFillColor: Color
    public var connectionColor: Color
    public var nodeSelectBackgroundColor: Color
    public var nodeSelectTextColor: Color
    public var nodeSelectViewWidth: CGFloat
    public var editorWidth: CGFloat
    public var editorHeight: CGFloat
}
