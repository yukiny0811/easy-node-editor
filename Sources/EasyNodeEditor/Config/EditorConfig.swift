//
//  File.swift
//  
//
//  Created by クワシマ・ユウキ on 2022/09/27.
//

import SwiftUI

public struct EditorConfig {
    public static let defaultConfig = EditorConfig(
        editorBackgroundColor: Color(red: 0.12, green: 0.12, blue: 0.12),
        nodeBackgroundColor: Color(red: 0.72, green: 0.72, blue: 0.72)
    )
    public var editorBackgroundColor: Color
    public var nodeBackgroundColor: Color
}
