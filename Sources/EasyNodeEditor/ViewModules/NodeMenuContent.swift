//
//  NodeMenuContent.swift
//  
//
//  Created by Yuki Kuwashima on 2022/11/20.
//

import SwiftUI

struct NodeMenuContent: View, Identifiable {
    let id = UUID()
    let nodeType: NodeModelBase.Type
    let editorConfig: EditorConfig
    @StateObject var manager = EasyNodeManager.shared
    var body: some View {
        HStack {
            Text(String(describing: nodeType))
                .foregroundColor(editorConfig.nodeSelectTextColor)
            Spacer()
            Button("add") {
                let temp = nodeType.init(editorConfig: editorConfig)
                manager.nodeModels[temp.id] = temp
            }
        }
    }
}
