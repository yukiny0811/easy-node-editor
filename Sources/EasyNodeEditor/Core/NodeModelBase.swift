//
//  NodeModelBase.swift
//  
//
//  Created by クワシマ・ユウキ on 2022/09/17.
//

import SwiftUI

public class NodeModelBase: NSObject, Identifiable, ObservableObject {
    public let id: String = UUID.init().uuidString
    var originalPosition: CGPoint = CGPoint(x: 0, y: 0)
    var movePosition: CGPoint = CGPoint.zero
    var outputConnection: [String: (nodeID: String, inputName: String)] = [:]
    @Published var frameSize: CGSize = CGSize.zero
    func processOnChange() {}
    func content() -> AnyView {
        return AnyView(Group{})
    }
}
