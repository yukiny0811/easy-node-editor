//
//  File.swift
//  
//
//  Created by クワシマ・ユウキ on 2022/09/17.
//

import SwiftUI

struct OutputNode: View {
    let idString: (nodeID: String, outputName: String)
    var body: some View {
        HStack {
            Text(idString.outputName)
            Rectangle()
                .fill(.yellow)
                .frame(width: 20, height: 20, alignment: .leading)
                .gesture(DragGesture()
                    .onChanged(){ _ in
                        if EasyNodeManager.shared.selectedOutputID == nil {
                            EasyNodeManager.shared.selectedOutputID = self.idString
                        } else {
                            if EasyNodeManager.shared.selectedOutputID! != self.idString {
                                EasyNodeManager.shared.selectedOutputID = self.idString
                            }
                        }
                    }
                    .onEnded() { _ in
                        guard let oID = EasyNodeManager.shared.selectedOutputID else {
                            EasyNodeManager.shared.selectedOutputID = nil
                            EasyNodeManager.shared.selectedInputID = nil
                            return
                        }
                        guard let iID = EasyNodeManager.shared.selectedInputID else {
                            EasyNodeManager.shared.selectedOutputID = nil
                            EasyNodeManager.shared.selectedInputID = nil
                            return
                        }
                        if oID != self.idString {
                            EasyNodeManager.shared.selectedOutputID = nil
                            EasyNodeManager.shared.selectedInputID = nil
                            return
                        }
                        if oID.0 == iID.0 {
                            EasyNodeManager.shared.selectedOutputID = nil
                            EasyNodeManager.shared.selectedInputID = nil
                            return
                        }
                        guard EasyNodeManager.shared.nodeModels[oID.0] != nil else {
                            return
                        }
                        EasyNodeManager.shared.nodeModels[oID.0]!.outputConnection[oID.1] = iID
                        let tempValue = EasyNodeManager.shared.nodeModels[oID.0]!.value(forKey: oID.1)
                        EasyNodeManager.shared.nodeModels[oID.0]!.setValue(tempValue, forKey: oID.1)
                        EasyNodeManager.shared.selectedOutputID = nil
                        EasyNodeManager.shared.selectedInputID = nil
                        return
                    }
                )
        }
        .frame(width: 200, height: 30, alignment: .trailing)
    }
}
