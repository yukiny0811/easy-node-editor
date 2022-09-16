//
//  EasyNodeEditor.swift
//
//
//  Created by クワシマ・ユウキ on 2022/09/17.
//

import SwiftUI

@available(macOS 10.15, *)
public struct EasyNodeEditor: View, Identifiable {
    let nodeTypes: [Initializable] = []
    public init() {}
    public let id: String = UUID.init().uuidString
    @StateObject var manager = EasyNodeManager.shared
    @State var selectedNode: NodeModelBase?
    public var body: some View {
        ZStack {
            GeometryReader { globalReader in
                ScrollView([.horizontal, .vertical], showsIndicators: true) {
                    GeometryReader { reader in
                        ZStack {
                            Button("add") {
                                let temp = TestModel()
                                manager.nodeModels[temp.id] = temp
                            }
                            ForEach(Array(manager.nodeModels.values)) { nm in
                                VStack(alignment: .leading, spacing: 0) {
                                    Rectangle()
                                        .frame(width: 20, height: 20)
                                    nm.content()
                                        .fixedSize()
                                        .background(
                                            GeometryReader { g -> AnyView in
                                                nm.frameSize = g.frame(in: .local).size
                                                return AnyView(Group{})
                                            }
                                        )
                                }
                                .border(.gray, width: 3)
                                .position(nm.originalPosition + nm.movePosition)
                                .fixedSize()
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            if self.selectedNode == nil {
                                                self.selectedNode = nm
                                            }
                                            self.selectedNode?.movePosition = value.translation.toCGPoint()
                                            manager.objectWillChange.send()
                                        }
                                        .onEnded { _ in
                                            guard let selected = self.selectedNode else {
                                                return
                                            }
                                            print("ended")
                                            selected.originalPosition += selected.movePosition
                                            selected.movePosition = CGPoint.zero
                                            self.selectedNode = nil
                                            manager.objectWillChange.send()
                                        }
                                )
                                ForEach(0..<Array(Mirror(reflecting: nm).children).count) { i in
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
                                            let n = manager.nodeModels[destNodeId]!
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
                                                                path.move(to: nm.originalPosition + nm.movePosition - CGPoint(x: 0, y: 15 + (Array(Mirror(reflecting: nm).children).count - i - 1) * 30) + CGPoint(x: 750, y: 750))
                                                                path.addLine(to: n.movePosition + nPos + CGPoint(x: 0, y: 15 + ind * 30) - nm.frameSize.toCGPoint() + CGPoint(x: 750, y: 750))
                                                            }
                                                                .stroke(.red, lineWidth: 3)
                                                        )
                                                    }
                                                }
                                            }
                                        }
                                        return AnyView(
                                            Group{}
                                        )
                                    }
                                    .frame(width: 1500, height: 1500, alignment: .trailing)
                                    .fixedSize()
                                }
                            }
                        }
                        .frame(minWidth: 1500, minHeight: 1500, alignment: .center)
                    }
                    .frame(minWidth: 1500, minHeight: 1500, alignment: .leading)
                }
                VStack {
                    Text("test")
                }
                .frame(minWidth: 200, maxWidth: 200, minHeight: globalReader.frame(in: .global).height, maxHeight: globalReader.frame(in: .global).height)
                .background(Color(red: 0.8, green: 0.8, blue: 0.8))
            }
        }
        .fixedSize(horizontal: false, vertical: false)
    }
}
