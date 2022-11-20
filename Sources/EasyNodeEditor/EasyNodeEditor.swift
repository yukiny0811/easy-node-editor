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
    public init(nodeTypes: [NodeModelBase.Type], editorConfig: EditorConfig? = nil) {
        self.nodeTypes = nodeTypes
        if let editorConfig = editorConfig {
            self.editorConfig = editorConfig
        } else {
            self.editorConfig = EditorConfig.defaultConfig
        }
    }
    public let id: String = UUID.init().uuidString
    @StateObject var manager = EasyNodeManager.shared
    @ObservedObject var selectedNodeModel = SelectedNodeModel()
    private let editorConfig: EditorConfig
    
    private var NodeGroup: some View {
        ForEach(Array(manager.nodeModels.values)) { nm in
            Node(nm: nm, editorConfig: editorConfig)
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
                Line(nm: nm, i: i, editorConfig: editorConfig)
                    .frame(width: editorConfig.editorWidth, height: editorConfig.editorHeight, alignment: .trailing)
                    .fixedSize()
            }
        }
    }
    
    public var body: some View {
        ZStack {
            GeometryReader { globalReader in
                ScrollView([.horizontal, .vertical], showsIndicators: true) {
                    ZStack {
                        NodeGroup
                    }
                    .frame(minWidth: editorConfig.editorWidth, minHeight: editorConfig.editorHeight, alignment: .center)
                }
                .background(editorConfig.editorBackgroundColor)
                VStack {
                    HStack {
                        Text("Nodes")
                            .font(.title)
                            .foregroundColor(editorConfig.nodeSelectTextColor)
                            .padding(EdgeInsets(top: 10, leading: 25, bottom: 0, trailing: 0))
                        Spacer()
                    }
                    List {
                        ForEach(0..<nodeTypes.count) { i in
                            NodeMenuContent(nodeType: nodeTypes[i], editorConfig: editorConfig)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                .frame(minWidth: 200, maxWidth: 200)
                            Divider()
                        }
                    }
                }
                .padding(0)
                .frame(minWidth: editorConfig.nodeSelectViewWidth, maxWidth: editorConfig.nodeSelectViewWidth, minHeight: globalReader.frame(in: .global).height, maxHeight: globalReader.frame(in: .global).height)
                .background(editorConfig.nodeSelectBackgroundColor)
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
