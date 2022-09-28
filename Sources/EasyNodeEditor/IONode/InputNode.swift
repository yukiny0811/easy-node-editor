//
//  File.swift
//  
//
//  Created by クワシマ・ユウキ on 2022/09/17.
//

import SwiftUI

struct InputNode: View {
    let idString: (nodeID: String, inputName: String)
    let editorConfig: EditorConfig
    var body: some View {
        HStack {
            TouchEventView(view: NSTouchEventView(frame: NSRect(x: 0, y: 0, width: 20, height: 20), idString: self.idString))
                .frame(width: 20, height: 20, alignment: .leading)
                .background(editorConfig.ioRectFillColor)
            Text(idString.inputName)
        }
        .frame(width: 200, height: 30, alignment: .leading)
    }
}
