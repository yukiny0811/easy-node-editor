//
//  EasyNodeManager.swift
//  
//
//  Created by クワシマ・ユウキ on 2022/09/17.
//

import SwiftUI

public class EasyNodeManager: ObservableObject {
    public static let shared = EasyNodeManager()
    @Published var nodeModels: [String: NodeModelBase] = [:]
    @Published var selectedInputID: (nodeID: String, inputName: String)?
    @Published var selectedOutputID: (nodeID: String, outputName: String)?
}
