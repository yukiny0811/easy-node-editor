//
//  EasyNodeEditor.swift
//
//
//  Created by クワシマ・ユウキ on 2022/09/17.
//

import SwiftUI

class SelectedNodeModel : ObservableObject{
    @Published var selectedNode: NodeModelBase?
}

@available(macOS 12.0, *)
public struct EasyNodeEditor: View, Identifiable {
    private let nodeTypes: [NodeModelBase.Type]
    public init(nodeTypes: [NodeModelBase.Type], editorConfig: EditorConfig = EditorConfig.defaultConfig) {
        self.nodeTypes = nodeTypes
        self.editorConfig = editorConfig
    }
    public let id: String = UUID.init().uuidString
    @StateObject var manager = EasyNodeManager.shared
    @ObservedObject var selectedNodeModel = SelectedNodeModel()
    private let editorConfig: EditorConfig
    public var body: some View {
        ZStack {
            GeometryReader { globalReader in
                ScrollView([.horizontal, .vertical], showsIndicators: true) {
                    GeometryReader { reader in
                        ZStack {
                            ForEach(Array(manager.nodeModels.values)) { nm in
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack {
                                        Rectangle()
                                            .fill(Color(red: 0.95, green: 0.95, blue: 0.95))
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
                                .background(editorConfig.nodeBackgroundColor)
                                .cornerRadius(5)
                                .position(nm.originalPosition + nm.movePosition)
                                .fixedSize()
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            if self.selectedNodeModel.selectedNode == nil {
                                                self.selectedNodeModel.selectedNode = nm
                                            }
                                            self.selectedNodeModel.selectedNode?.movePosition = value.translation.toCGPoint()
                                            self.selectedNodeModel.objectWillChange.send()
//                                            manager.objectWillChange.send()
                                        }
                                        .onEnded { _ in
                                            guard let selected = self.selectedNodeModel.selectedNode else {
                                                return
                                            }
                                            selected.originalPosition += selected.movePosition
                                            selected.movePosition = CGPoint.zero
                                            self.selectedNodeModel.selectedNode = nil
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
                                                                path.move(to: nm.originalPosition + nm.movePosition - CGPoint(x: 0, y: 15 + (Array(Mirror(reflecting: nm).children).count - i - 1) * 30) + CGPoint(x: 750, y: 750))
                                                                path.addLine(to: n.movePosition + nPos + CGPoint(x: 0, y: 15 + ind * 30) - n.frameSize.toCGPoint() + CGPoint(x: 750, y: 750))
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
                .background(editorConfig.editorBackgroundColor)
                VStack {
                    HStack {
                        Text("Nodes")
                            .font(.title)
                            .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                            .padding(EdgeInsets(top: 10, leading: 25, bottom: 0, trailing: 0))
                        Spacer()
                    }
                    List {
                        ForEach(0..<nodeTypes.count) { i in
                            HStack() {
                                Text(String(describing: nodeTypes[i]))
                                    .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                                Spacer()
                                Button("add") {
                                    let temp = nodeTypes[i].init()
                                    manager.nodeModels[temp.id] = temp
                                }
                            }
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .frame(minWidth: 200, maxWidth: 200)
                            Divider()
                        }
                    }
                }
                .padding(0)
                .frame(minWidth: 230, maxWidth: 230, minHeight: globalReader.frame(in: .global).height, maxHeight: globalReader.frame(in: .global).height)
                .background(Color(red: 0.3, green: 0.3, blue: 0.3))
            }
        }
        .fixedSize(horizontal: false, vertical: false)
    }
}

fileprivate extension NSTableView {
    open override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        backgroundColor = NSColor.clear
        enclosingScrollView!.drawsBackground = false
    }
}
