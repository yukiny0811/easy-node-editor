//
//  Node.swift
//  
//
//  Created by Yuki Kuwashima on 2022/11/20.
//

import SwiftUI

@available(macOS 12.0, *)
struct Node: View, Identifiable {
    let id = UUID()
    let nm: NodeModelBase
    let editorConfig: EditorConfig
    @StateObject var manager = EasyNodeManager.shared
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Rectangle()
                    .fill(editorConfig.moveFillColor)
                    .cornerRadius(5)
                    .frame(width: 20, height: 20)
                Spacer()
                Button("X") {
                    EasyNodeManager.shared.nodeModels[nm.id] = nil
                    manager.objectWillChange.send()
                }
                .frame(height: 20)
                .buttonStyle(.borderedProminent)
                .tint(Color.red)
            }
            nm.content()
                .fixedSize()
                .background(
                    GeometryReader { g -> AnyView in
                        nm.frameSize = g.frame(in: .local).size
                        return AnyView(Group{})
                    }
                )
        }
    }
}
