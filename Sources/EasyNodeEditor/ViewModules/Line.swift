//
//  Line.swift
//  
//
//  Created by Yuki Kuwashima on 2022/11/20.
//

import SwiftUI

struct Line: View, Identifiable {
    let id = UUID()
    let nm: NodeModelBase
    let i: Int
    let editorConfig: EditorConfig
    @StateObject var manager = EasyNodeManager.shared
    var body: some View {
        VStack(alignment: .leading, spacing: 0) { () -> AnyView in
            let elem = Array(Mirror(reflecting: nm).children)[i]
            let rawString = String(describing: elem.value)
            guard var rawLabel = elem.label else {
                return AnyView(
                    Group{}
                )
            }
            if rawString.contains("Output<") {
                rawLabel.removeFirst()
                guard nm.outputConnection[rawLabel] != nil else {
                    return AnyView(
                        Group{}
                    )
                }
                let destNodeId = nm.outputConnection[rawLabel]!.nodeID
                let destInputName = nm.outputConnection[rawLabel]!.inputName
                let n = manager.nodeModels[destNodeId]
                guard let n = n else {
                    nm.outputConnection[rawLabel] = nil
                    self.manager.objectWillChange.send()
                    return AnyView(Group{})
                }
                let nElemArray = Array(Mirror(reflecting: n).children)
                for ind in 0..<nElemArray.count {
                    let nElem = nElemArray[ind]
                    let nElemRawString = String(describing: nElem.value)
                    guard var nElemRawLabel = nElem.label else {
                        return AnyView(
                            Group{}
                        )
                    }
                    if nElemRawString.contains("Input<") {
                        nElemRawLabel.removeFirst()
                        if nElemRawLabel == destInputName {
                            let nPos = n.originalPosition
                            return AnyView(
                                Path { path in
                                    path.move(to: nm.originalPosition + nm.movePosition - CGPoint(x: 0, y: 15 + (Array(Mirror(reflecting: nm).children).count - i - 1) * 30) + CGPoint(x: editorConfig.editorWidth / 2, y: editorConfig.editorHeight / 2))
                                    path.addLine(to: n.movePosition + nPos + CGPoint(x: 0, y: 15 + ind * 30) - n.frameSize.toCGPoint() + CGPoint(x: editorConfig.editorWidth / 2, y: editorConfig.editorHeight / 2))
                                }
                                    .stroke(editorConfig.connectionColor, lineWidth: 3)
                            )
                        }
                    }
                }
            }
            return AnyView(
                Group{}
            )
        }
    }
}
