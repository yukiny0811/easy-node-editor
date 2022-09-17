//
//  File.swift
//  
//
//  Created by クワシマ・ユウキ on 2022/09/17.
//

import SwiftUI

struct InputNode: View {
    let idString: (nodeID: String, inputName: String)
    var body: some View {
        HStack {
//            Rectangle()
//                .fill(.yellow)
//                .frame(width: 20, height: 20, alignment: .leading)
//                .onHover{ hovering in
//                    EasyNodeManager.shared.selectedInputID = self.idString
//                }
            TouchEventView(view: NSTouchEventView(frame: NSRect(x: 0, y: 0, width: 20, height: 20), idString: self.idString))
                .frame(width: 20, height: 20, alignment: .leading)
                .background(Color.yellow)
            Text(idString.inputName)
        }
        .frame(width: 200, height: 30, alignment: .leading)
        .background(Color(red: 0.8, green: 0.8, blue: 0.8))
    }
}
