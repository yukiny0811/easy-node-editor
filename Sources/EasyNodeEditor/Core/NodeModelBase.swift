//
//  NodeModelBase.swift
//  
//
//  Created by クワシマ・ユウキ on 2022/09/17.
//

import SwiftUI

open class NodeModelBase: NSObject, Identifiable, ObservableObject, Initializable {
    public required override init() {}
    public let id: String = UUID.init().uuidString
    var originalPosition: CGPoint = CGPoint(x: 0, y: 0)
    var movePosition: CGPoint = CGPoint.zero
    var outputConnection: [String: (nodeID: String, inputName: String)] = [:]
    @Published var frameSize: CGSize = CGSize.zero
    func processOnChange() {}
    func content() -> AnyView {
        let mir = Mirror(reflecting: self).children
        let mirArray = Array(mir)
        var inputArray: [String] = []
        var outputArray: [String] = []
        for i in 0..<mirArray.count {
            let elem = mirArray[i]
            let rawString = String(describing: elem.value.self)
            if rawString.contains("Input<") {
                if var rawLabel = elem.label {
                    rawLabel.removeFirst()
                    inputArray.append(rawLabel)
                }
            }
            if rawString.contains("Output<") {
                if var rawLabel = elem.label {
                    rawLabel.removeFirst()
                    outputArray.append(rawLabel)
                }
            }
        }
        return AnyView(
            VStack {
                ForEach (0..<inputArray.count) { i in
                    InputNode(idString: (nodeID: self.id, inputName: inputArray[i]))
                }
                middleContent()
                ForEach (0..<outputArray.count) { o in
                    OutputNode(idString: (nodeID: self.id, outputName: outputArray[o]))
                }
            }
        )
    }
    func middleContent() -> AnyView {
        return AnyView(Group{})
    }
}
